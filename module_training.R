# BUSINESS SCIENCE ----
# DS4B 202-R ----
# AUTHENTICATION & MODULE TRAINING -----
# Version 1

# APPLICATION DESCRIPTION ----
# - Render a Login Dialog Page
# - Dynamically render a UI upon authentication
# - Create a module to produce the login
# - Use the shinyauthr package

library(shiny)
library(shinythemes)
library(shinyjs)
library(tidyverse)

library(shinyauthr)

source("mod_auth.R")

ui <- navbarPage(
    title = "Module Training", 
    theme = shinytheme("flatly"),
    collapsible = TRUE,
    
    tabPanel(
        useShinyjs(),
        title = "Login Module",
        
        h2("No Module"),
        
        div(
            id = "login",
            style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
            div(
                class = "well",
                h2(class = "text-center", "Please Login"),
                textInput(
                    inputId = "user_name",
                    label = tagList(icon("user"), "User Name"),
                    placeholder = "Enter user name"
                ),
                passwordInput(
                    inputId = "password",
                    label = tagList(icon("unlock-alt"), "Password"),
                    placeholder = "Enter password"
                ),
                div(
                    class = "text-center",
                    actionButton(
                        inputId = "login_button",
                        label = "Login",
                        class = "btn-primary",
                        style = "color: white;"
                    )
                )
            )
        ),
        
        uiOutput(outputId = "display_content"),
        
        h2("Using A Module"),
        auth_ui("auth"),
        uiOutput(outputId = "display_content_2"),
        
        
        h2('Using Shiny Auth'),
        div(
            class = "pull-right",
            logoutUI(id = "logout")
        ),
        loginUI(id = "login_2"),
        tableOutput("user_table")
        
    )
)

server <- function(input, output, session) {
    
    user_base_tbl <- tibble(
        user_name = "user1",
        password  = "pass1"
    )
    
    # NO MODULE ----
    
    validate_password <- eventReactive(
        eventExpr = input$login_button,
        valueExpr = {
            validate <- FALSE
            
            if (input$user_name == user_base_tbl$user_name && 
                input$password == user_base_tbl$password) {
                validate <- TRUE
            }
        }
    )
    
    output$display_content <- renderUI({
        
        req(validate_password())
        
        div(
            id = "success",
            h1(class = "page-header",
               "Stock Analyser",
               tags$small("by BS")),
            p(class = "lead", "Page content ...")
        )
    })
    
    # MODULE ----
    validate_password_2 <- auth_server("auth", user_base_tbl)
    
    output$display_content_2 <- renderUI({
        
        req(validate_password_2())
        
        div(
            id = "success",
            h1(class = "page-header",
               "Stock Analyser",
               tags$small("by BS")),
            p(class = "lead", "Page content ...")
        )
    })
    
    
    # SHINYAUTHR ----
    credentials <- loginServer(
        id = "login_2",
        data = user_base_tbl,
        user_col = user_name,
        pwd_col = password,
        log_out = reactive(logout_init())
    )
    
    logout_init <- logoutServer(
        id = "logout",
        active = reactive(credentials()$user_auth)
    )
    
    output$user_table <- renderTable({
        req(credentials()$user_auth)
        credentials()$info
    })
    
}

shinyApp(ui, server)