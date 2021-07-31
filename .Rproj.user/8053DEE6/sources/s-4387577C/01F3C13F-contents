auth_ui <- function(id,
                    title = "Please Login") {
  
  ns <- NS(id)
  
  tagList(
    div(
      id = ns("login"),
      style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
      div(
        class = "well",
        h2(class = "text-center", title),
        textInput(
          inputId = ns("user_name"),
          label = tagList(icon("user"), "User Name"),
          placeholder = "Enter user name"
        ),
        passwordInput(
          inputId = ns("password"),
          label = tagList(icon("unlock-alt"), "Password"),
          placeholder = "Enter password"
        ),
        div(
          class = "text-center",
          actionButton(
            inputId = ns("login_button"),
            label = "Login",
            class = "btn-primary",
            style = "color: white;"
          )
        )
      )
    )
  )
}


auth_server <- function(id, user_base_tbl) {
  moduleServer(id, function(input, output, session) {
    
    ns <- NS(id)
    
    eventReactive(
      eventExpr = input$login_button,
      valueExpr = {
        validate <- FALSE
        
        if (input$user_name == user_base_tbl$user_name && 
            input$password == user_base_tbl$password) {
          validate <- TRUE
        }
        
        if (validate) {
          shinyjs::hide(id = ns("login"))
        }
        
        return(validate)
      }
    )
  })
  
}