<%@ page import="org.owasp.encoder.Encode" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="../authenticationendpoint/css/login.css" />
    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"
      integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    ></script>
    <script
      src="https://code.jquery.com/jquery-3.7.1.slim.min.js"
      integrity="sha256-kmHvs0B+OpCW5GVHUNjv9rOmY0IvSIRcf7zGUDTDQM8="
      crossorigin="anonymous"
    ></script>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css"
    />
    <title>Recupera mi contraseña | INVEX</title>
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
    <div class="center-content padding-32">
      <div class="SquareBox flex gap-24 column" style="max-width: 460px">
        <h2>Recuperar contraseña</h2>
        <p>
          Para realizar la recuperación de tu contraseña es necesario contar con
          tu usuario.
        </p>
        <div class="alert-message hide" id="alertMessage">
          <span
            ><i class="bi bi-x-circle-fill"></i>
            <span id="textAlerMessage"></span
          ></span>
          <button id="btnCloseAlert">
            <i class="bi bi-x"></i>
          </button>
        </div>
        <form
          class="flex gap-16 column"
          method="post" action="verify.do"
          id="recoverDetailsForm"
        >
          <input type="hidden" name="recoveryOption" value="EMAIL" checked />
          <% String callback = request.getParameter("callback"); if (callback !=
          null) { %>
          <div>
            <input
              type="hidden"
              name="callback"
              value="<%=Encode.forHtmlAttribute(callback) %>"
            />
          </div>
          <% } %> <% String sessionDataKey =
          request.getParameter("sessionDataKey"); if (sessionDataKey != null) {
          %>
          <div>
            <input
              type="hidden"
              name="sessionDataKey"
              value="<%=Encode.forHtmlAttribute(sessionDataKey) %>"
            />
          </div>
          <% } %>

          <div class="form__group field">
            <input
              type="text"
              class="form__field"
              placeholder="Ingresa tu usuario"
              name="username"
              id="username"
            />
            <label for="name" class="form__label">Ingresa tu usuario</label>
          </div>
          <button type="button" class="button-form" id="btnRecover">
            Enviar
          </button>
          <button type="button" class="button-text" id="btnBackLogin">
            Regresar
          </button>
        </form>
      </div>
    </div>
  </body>
  <script src="../authenticationendpoint/js/login.js"></script>
</html>
