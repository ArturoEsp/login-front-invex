<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="./css/login.css" />
    <script
      src="https://code.jquery.com/jquery-3.7.1.slim.min.js"
      integrity="sha256-kmHvs0B+OpCW5GVHUNjv9rOmY0IvSIRcf7zGUDTDQM8="
      crossorigin="anonymous"
    ></script>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css"
    />
    <title>Pantalla Única | Cuenta Crédito</title>
  </head>
  <body>
    <div class="Header">
      <div class="logo">
        <img
          src="https://d2ra1qv4p9we6t.cloudfront.net/uploads/b45a8fe4-7369-46c1-937f-40e77314dade/original/invex-logo.svg"
          alt="Logo INVEX"
        />
      </div>
    </div>
    <div class="Body">
      <div class="container-img">
        <h2>Bienvenido a INVEX</h2>
      </div>
      <div class="container-form">
        <div class="alert-message hide" id="alertMessage">
          <span
            ><i class="bi bi-x-circle-fill"></i>
            <span id="textAlerMessage"></span
          ></span>
          <button id="btnCloseAlert">
            <i class="bi bi-x"></i>
          </button>
        </div>
        <form action="../../commonauth" autocomplete="off" id="formSubmit">
          <h3>Inicia sesión</h3>
          <div class="form__group field">
            <input
              type="text"
              class="form__field"
              placeholder="Usuario o correo electrónico *"
              name="username"
              id="username"
            />
            <label for="name" class="form__label"
              >Usuario o correo electrónico *</label
            >
          </div>
          <div class="form__group field">
            <input
              type="password"
              class="form__field"
              placeholder="Contraseña *"
              name="password"
              id="password"
            />
            <label for="name" class="form__label">Contraseña *</label>
            <i class="bi bi-eye-slash" id="togglePassword"></i>
          </div>
          <input type="hidden" name="sessionDataKey" value="<%=request.getParameter("sessionDataKey")%>"/>
          <button type="button" class="button-form" id="btnSubmit">
            Iniciar sesión
          </button>
        </form>
      </div>
    </div>
  </body>
  <script src="./js/login.js"></script>
</html>
