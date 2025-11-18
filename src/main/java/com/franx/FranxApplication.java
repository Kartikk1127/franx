package com.franx;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main entry point of the application.
 * Bootstraps Spring Boot, initializes core configurations, and starts the reactive server
 * */
@SpringBootApplication
public class FranxApplication {
	public static void main(String[] args) {
		SpringApplication.run(FranxApplication.class, args);
	}

}
