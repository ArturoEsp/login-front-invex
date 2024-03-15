<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.IdentityManagementEndpointConstants" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.IdentityManagementEndpointUtil" %>
<%@ page import="java.io.File" %>


<%
    boolean error = IdentityManagementEndpointUtil.getBooleanValue(request.getAttribute("error"));
    String errorMsg = IdentityManagementEndpointUtil.getStringValue(request.getAttribute("errorMsg"));
    String callback = (String) request.getAttribute("callback");
    String tenantDomain = (String) request.getAttribute(IdentityManagementEndpointConstants.TENANT_DOMAIN);
    String username = request.getParameter("username");
    String sessionDataKey = request.getParameter("sessionDataKey");
    if (tenantDomain == null) {
        tenantDomain = (String) session.getAttribute(IdentityManagementEndpointConstants.TENANT_DOMAIN);
    }
    if (username == null) {
        username = (String) request.getAttribute("username");
    }
    if (sessionDataKey == null) {
        sessionDataKey = (String) request.getAttribute("sessionDataKey");
    }

%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="../authenticationendpoint/css/login.css" />
     <link rel="shortcut icon" href="https://www.invextarjetas.com.mx/invex/landings/LandingGenericaVolarisInvex/img/favicon.png" type="image/x-icon">
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
    <script src="../authenticationendpoint/js/utils.js"></script>
    <title>Cambia tu contrase&ntilde;a | INVEX</title>
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
        <h2>Ingresa tu nueva contrase&ntilde;a</h2>
        <p>
          Deberá tener un mínimo de 8 caracteres con al menos un número y un
          máximo de 18 caracteres.
        </p>

        <% if (error) { %>
        <div class="ui visible negative message">
            <%=errorMsg %>
        </div>
        <% } %>
        <div class="alert-message hide" id="alertMessage">
          <span
            ><i class="bi bi-x-circle-fill"></i>
            <span id="textAlertMessage"></span
          ></span>
          <button id="btnCloseAlert">
            <i class="bi bi-x"></i>
          </button>
        </div>
        <form
          class="flex gap-16 column"
          method="post"
          action="completepasswordreset.do"
          id="passwordResetForm"
        >
          <input type="hidden" name="recoveryOption" value="EMAIL" checked />
          <% if (username != null) { %>
          <div>
              <input type="hidden" name="username" value="<%=Encode.forHtmlAttribute(username) %>"/>
          </div>
          <% } %>
          <% if (callback != null) { %>
          <div>
              <input type="hidden" name="callback" value="<%=Encode.forHtmlAttribute(callback) %>"/>
          </div>
          <% } %>
          <% if (tenantDomain != null) { %>
          <div>
              <input type="hidden" name="tenantdomain" value="<%=Encode.forHtmlAttribute(tenantDomain) %>"/>
          </div>
          <% } %>
          <% if (sessionDataKey != null) { %>
          <div>
              <input type="hidden" name="sessionDataKey" value="<%=Encode.forHtmlAttribute(sessionDataKey)%>"/>
          </div>
          <% } %>
          <div>
            <input
              type="hidden"
              name="callback"
              value="<%=Encode.forHtmlAttribute(callback) %>"
            />
          </div>
          <div>
            <input
              type="hidden"
              name="sessionDataKey"
              value="<%=Encode.forHtmlAttribute(sessionDataKey) %>"
            />
          </div>

          <div class="form__group field">
            <input
              type="password"
              class="form__field"
              maxlength="18"
              placeholder="Ingresa tu nueva contrase&ntilde;a"
              name="reset-password"
              id="password"
            />
            <label for="name" class="form__label"
              >Ingresa tu nueva contrase&ntilde;a</label
            >
            <i class="bi bi-eye-slash" id="togglePassword"></i>
          </div>
          <div class="form__group field">
            <input
              type="password"
              class="form__field"
              maxlength="18"
              placeholder="Ingresa tu nueva contrase&ntilde;a"
              name="reset-password2"
              id="confirmPassword"
            />
            <label for="name" class="form__label"
              >Confirma tu nueva contrase&ntilde;a</label
            >
            <i class="bi bi-eye-slash" id="toggleConfirmPassword"></i>
          </div>
          <button type="button" class="button-form" id="btnRecover">
            Confirmar
          </button>
        </form>
      </div>
    </div>
  </body>
  <script>
    const selectorTextAlertMessage = "#textAlertMessage";
    const selectorAlertMessage = "#alertMessage";
    passwordEye("#password", "#togglePassword");
    passwordEye("#confirmPassword", "#toggleConfirmPassword");
    hideMessageError("#btnCloseAlert", selectorAlertMessage);
    const passw = /^(?=.*[0-9])(?=.*[a-zA-Z])(?=\S+$).{6,20}$/;
  
    $("#btnRecover").click(function (e) {
      const password = $("#password").val();
      const password2 = $("#confirmPassword").val();
      showMessageError(selectorTextAlertMessage, selectorAlertMessage, null);

      if (!password || 0 === password.length) {
        showMessageError(
          selectorTextAlertMessage,
          selectorAlertMessage,
          "Ingresa tu nueva contraseña."
        );
        return;
      }

      if (password !== password2) {
        showMessageError(
          selectorTextAlertMessage,
          selectorAlertMessage,
          "Las contraseñas no conciden."
        );
        return;
      }

      if (!password.match(passw)) {
        showMessageError(
          selectorTextAlertMessage,
          selectorAlertMessage,
          "La contraseña no cumple con los minimos requisitos."
        );
        return;
      }

      $("#passwordResetForm").submit();
    });
  </script>
</html>
