package com.x;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController

public class StartApplication {

    @GetMapping("/")
    public String index() {
        return "Success";
    }
    @GetMapping("/health")
    public String health() {
        return "healthy!";
    }
    public static void main(String[] args) {
        SpringApplication.run(StartApplication.class, args);
    }

}
