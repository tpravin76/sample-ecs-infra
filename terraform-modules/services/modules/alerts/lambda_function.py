import json
import boto3
import os

sns_arn = os.environ['sns_arn']
subject = "Changes in ECS tasks."

def lambda_handler(event, context):
    result = {}
    client = boto3.client("sns")

    if event["source"] != "aws.ecs":
       raise ValueError("Function only supports input from events with a source type of: aws.ecs")

    if (event['detail-type'] == 'ECS Task State Change' or event['detail-type'] == 'ECS Container Instance State Change' or event['detail-type'] == 'ECS Deployment State Change'):
        result['event'] = event['detail-type']
        subject = event['detail-type']
    else:
        raise ValueError("detail-type for event is not a supported type. Exiting without saving event.")

    result['lastStatus'] = ''
    try:
        for i in event['detail']['containers']:
            result['lastStatus'] = i['lastStatus']
    except:
        print('could not get containers info')


    result['time'] = event['time']
    result['resources'] = event['resources']

    result['reason'] = ''
    try:
       result['reason'] = event['detail']['reason']
    except:
        print('could not get reason info')


    message = "Event: {}\nTime: {}\nStatus: {}\nResources: {}\nReason: {}".format(result['event'], result['time'], result['lastStatus'], result['resources'], result['reason'])

    resp = client.publish(TargetArn=sns_arn, Message=message, Subject=subject)
