<%@ page import="org.owasp.encoder.Encode" %> 
<%
  boolean error = IdentityManagementEndpointUtil.getBooleanValue(request.getAttribute("error"));
  String errorMsg = IdentityManagementEndpointUtil.getStringValue(request.getAttribute("errorMsg"));
  String username = request.getParameter("username");
  boolean isSaaSApp = Boolean.parseBoolean(request.getParameter("isSaaSApp"));
  String tenantDomain = request.getParameter("tenantDomain");

  ReCaptchaApi reCaptchaApi = new ReCaptchaApi();
  try {
      ReCaptchaProperties reCaptchaProperties = reCaptchaApi.getReCaptcha(tenantDomain, true, "ReCaptcha",
              "password-recovery");

      if (reCaptchaProperties.getReCaptchaEnabled()) {
          Map<String, List<String>> headers = new HashMap<>();
          headers.put("reCaptcha", Arrays.asList(String.valueOf(true)));
          headers.put("reCaptchaAPI", Arrays.asList(reCaptchaProperties.getReCaptchaAPI()));
          headers.put("reCaptchaKey", Arrays.asList(reCaptchaProperties.getReCaptchaKey()));
          IdentityManagementEndpointUtil.addReCaptchaHeaders(request, headers);
      }
  } catch (ApiException e) {
      request.setAttribute("error", true);
      request.setAttribute("errorMsg", e.getMessage());
      request.getRequestDispatcher("error.jsp").forward(request, response);
      return;
  }

  boolean isEmailNotificationEnabled = false;

  isEmailNotificationEnabled = Boolean.parseBoolean(application.getInitParameter(
          IdentityManagementEndpointConstants.ConfigConstants.ENABLE_EMAIL_NOTIFICATION));

  boolean reCaptchaEnabled = false;

  if (request.getAttribute("reCaptcha") != null &&
          "TRUE".equalsIgnoreCase((String) request.getAttribute("reCaptcha"))) {
      reCaptchaEnabled = true;
  }

  String emailUsernameEnable = application.getInitParameter("EnableEmailUserName");
  Boolean isEmailUsernameEnabled = false;

  if (StringUtils.isNotBlank(emailUsernameEnable)) {
      isEmailUsernameEnabled = Boolean.valueOf(emailUsernameEnable);
  } else {
      isEmailUsernameEnabled = isEmailUsernameEnabled();
  }
%>

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
    <title>Recupera mi contrase&ntilde;a | INVEX</title>
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
        <h2>Recuperar contrase&ntilde;a</h2>
        <p>
          Para realizar la recuperaci&oacute;n de tu contrase&ntilde;a es
          necesario contar con tu usuario.
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
          method="post"
          action="verify.do"
          id="recoverDetailsForm"
        >
          <input type="hidden" name="recoveryOption" value="EMAIL" checked />
          <% String callback = request.getParameter("callback"); 
            if (callback != null) { %>
          <div>
            <input
              type="hidden"
              name="callback"
              value="<%=Encode.forHtmlAttribute(callback) %>"
            />
          </div>
          <% } %> <% String sessionDataKey = request.getParameter("sessionDataKey"); 
            if (sessionDataKey != null) {
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
              name="usernameUserInput"
              id="usernameUserInput"
            />
            <input id="username" name="username" type="hidden" required>
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
    <script>
      $(document).ready(function () {

        $("#recoverDetailsForm").submit(function (e) {
            var errorMessage = $("#error-msg");
            errorMessage.hide();

            var isSaaSApp = JSON.parse("<%= isSaaSApp %>");
            var tenantDomain = "<%= tenantDomain %>";
            var isEmailUsernameEnabled = JSON.parse("<%= isEmailUsernameEnabled %>");

            var userName = document.getElementById("username");
            var usernameUserInput = document.getElementById("usernameUserInput");
            var usernameUserInputValue = usernameUserInput.value.trim();

            if ((tenantDomain !== "null") && !isSaaSApp) {
                if (!isEmailUsernameEnabled && (usernameUserInputValue.split("@").length >= 2)) {

                    errorMessage.text(
                        "Invalid Username. Username shouldn't have '@' or any other special characters.");
                    errorMessage.show();

                    return;
                }

                if (isEmailUsernameEnabled && (usernameUserInputValue.split("@").length <= 1)) {

                    errorMessage.text("Invalid Username. Username has to be an email address.");
                    errorMessage.show();

                    return;
                }

                userName.value = usernameUserInputValue + "@" + tenantDomain;
            } else {
                userName.value = usernameUserInputValue;
            }


            var firstName = $("#username").val();

            if (firstName == '') {
                errorMessage.text("Please fill the first name.");
                errorMessage.show();
                $("html, body").animate({scrollTop: errorMessage.offset().top}, 'slow');

                return false;
            }

            // Validate reCaptcha
            <% if (reCaptchaEnabled) { %>

            var reCaptchaResponse = $("[name='g-recaptcha-response']")[0].value;

            if (reCaptchaResponse.trim() == '') {
                errorMessage.text("Please select reCaptcha.");
                errorMessage.show();
                $("html, body").animate({scrollTop: errorMessage.offset().top}, 'slow');

                return false;
            }

            <% } %>

            return true;
        });
      });
    </script>
  </body>
</html>
