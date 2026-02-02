Here is a detailed explanation of **Part X - Section D: Internationalization (i18n) & Localization (l10n)** within the context of Spring Boot.

---

# Internationalization (i18n) & Localization (l10n) in Spring Boot

In the context of a software application:
*   **Internationalization (i18n):** The architectural process of designing your application so that it can be adapted to various languages and regions without engineering changes. (i.e., making the app "translatable").
*   **Localization (l10n):** The specific process of adapting that internationalized software for a specific region or language by adding locale-specific components (translating text, formatting dates, currencies, etc.).

Spring Boot provides robust, auto-configured support for i18n through the `MessageSource` interface and `LocaleResolver`.

---

### 1. The Core Components

To implement i18n, Spring Boot relies on three main concepts:

#### A. Resource Bundles (`.properties` files)
Instead of hardcoding strings in your Java code (e.g., `return "Hello World";`), you store these strings in external properties files based on the language.

#### B. MessageSource
This is the Spring interface responsible for resolving messages from the Resource Bundles based on a specific `Locale` (language/country).

#### C. LocaleResolver
This interface determines *which* locale is currently active. It figures this out based on HTTP Headers, Sessions, Cookies, or a fixed default.

---

### 2. Implementation Guide

Here is how you implement i18n in a standard Spring Boot REST API.

#### Step 1: Create Resource Bundles
By default, Spring Boot looks for message files in `src/main/resources`. It's best practice to keep them organized, e.g., in a folder named `i18n` or just `messages`.

**Directory Structure:**
```text
src/main/resources/
├── application.properties
└── messages.properties       (Default / Fallback)
└── messages_fr.properties    (French)
└── messages_de.properties    (German)
```

**Content of `messages.properties` (Default - usually English):**
```properties
greeting.message=Hello World!
error.notfound=User not found.
param.required=The {0} parameter is required.
```

**Content of `messages_fr.properties` (French):**
```properties
greeting.message=Bonjour le monde!
error.notfound=Utilisateur non trouvé.
param.required=Le paramètre {0} est requis.
```

#### Step 2: Configure Spring Boot
Tell Spring Boot where to find these files in your `application.properties` or `application.yml`.

```properties
# application.properties
# If files are in src/main/resources/
spring.messages.basename=messages 

# If files are in src/main/resources/i18n/
# spring.messages.basename=i18n/messages

# Fallback to the system locale if no specific locale is found?
spring.messages.fallback-to-system-locale=false

# Encoding (Crucial for non-Latin characters)
spring.messages.encoding=UTF-8
```

#### Step 3: Determining the Locale (`LocaleResolver`)
For a **REST API** (stateless), the industry standard is to determine the language via the **`Accept-Language`** HTTP Header sent by the client (browser or mobile app).

Spring Boot uses `AcceptHeaderLocaleResolver` by default. However, you can customize it to set a specific default (e.g., US English) if the header is missing.

**Configuration Class:**
```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver;

import java.util.Locale;

@Configuration
public class LocaleConfig {

    @Bean
    public LocaleResolver localeResolver() {
        AcceptHeaderLocaleResolver localeResolver = new AcceptHeaderLocaleResolver();
        // Set a default if the Accept-Language header is missing
        localeResolver.setDefaultLocale(Locale.US);
        return localeResolver;
    }
}
```

---

### 3. Usage in Controller (REST API)

There are two ways to retrieve the translated message.

#### Approach A: Injecting `MessageSource` (Recommended)
You inject the `MessageSource` bean and use `LocaleContextHolder` to get the current request's locale.

```java
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController {

    private final MessageSource messageSource;

    public GreetingController(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    @GetMapping("/hello")
    public String getGreeting() {
        // 1. Get the key from properties file
        // 2. Pass arguments (null here)
        // 3. Get the locale from the current HTTP Request context
        return messageSource.getMessage(
                "greeting.message", 
                null, 
                LocaleContextHolder.getLocale()
        );
    }
}
```

**Testing Approach A via Postman/Curl:**
1.  **Request:** `GET /hello` (No Header) $\rightarrow$ **Response:** "Hello World!" (Default)
2.  **Request:** `GET /hello` (Header `Accept-Language: fr`) $\rightarrow$ **Response:** "Bonjour le monde!"

#### Approach B: Passing Arguments
If your message is `The {0} parameter is required.`, you can pass dynamic data.

```java
@GetMapping("/param-test")
public String getParamError() {
    Object[] args = new Object[]{"EMAIL_ID"};
    
    return messageSource.getMessage(
            "param.required", 
            args, 
            LocaleContextHolder.getLocale()
    );
}
// Response (En): "The EMAIL_ID parameter is required."
// Response (Fr): "Le paramètre EMAIL_ID est requis."
```

---

### 4. Advanced: Validation Messages
A very common use case is localizing `@Valid` error messages in DTOs.

**The DTO:**
```java
public class UserDto {
    
    // The message key corresponds to a key in messages.properties
    @NotNull(message = "{error.notfound}") 
    private String username;
    
    // ...
}
```
You then need to configure your `LocalValidatorFactoryBean` to use your custom `MessageSource` so it knows where to look for `{error.notfound}`.

---

### 5. Formatting (Dates and Currencies)
Localization isn't just about text; it is also about numbers and dates.

*   **US format:** 1,000.99 / MM/DD/YYYY
*   **Germany format:** 1.000,99 / DD.MM.YYYY

Java's standard library handles this using the Locale resolved by Spring:

```java
@GetMapping("/money")
public String getMoney() {
    Locale currentLocale = LocaleContextHolder.getLocale();
    double payment = 12345.67;
    
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(currentLocale);
    return currencyFormatter.format(payment);
}
// Header: Accept-Language: en-US -> $12,345.67
// Header: Accept-Language: fr-FR -> 12 345,67 €
```

### Summary of Best Practices
1.  **UTF-8 Everywhere:** Ensure your IDE and `application.properties` are set to UTF-8 to handle accents and Asian characters correctly.
2.  **Code for Default:** Always write your code assuming English (or your primary language) is the fallback.
3.  **Don't hardcode Strings:** Even if you don't plan to translate immediately, using `messages.properties` separates content from logic, making maintenance easier.
4.  **Use `LocaleContextHolder`:** In a web request, let Spring manage the Locale lifecycle rather than passing a `Locale` object manually through every method call in your service layer.
