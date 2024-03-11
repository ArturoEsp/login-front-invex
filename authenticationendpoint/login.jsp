<%@ page import="org.apache.cxf.jaxrs.client.JAXRSClientFactory" %>
<%@ page import="org.apache.cxf.jaxrs.provider.json.JSONProvider" %>
<%@ page import="org.apache.cxf.jaxrs.client.WebClient" %>
<%@ page import="org.apache.http.HttpStatus" %>
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.client.SelfUserRegistrationResource" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.AuthenticationEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.bean.ResendCodeRequestDTO" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.bean.UserDTO" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="javax.ws.rs.core.Response" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.isSelfSignUpEPAvailable" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.isRecoveryEPAvailable" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.isEmailUsernameEnabled" %>
<%@ page import="static org.wso2.carbon.identity.core.util.IdentityUtil.getServerURL" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="org.wso2.carbon.base.ServerConfiguration" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.endpoint.util.EndpointConfigManager" %>

<%
    private static final String JAVAX_SERVLET_FORWARD_REQUEST_URI = "javax.servlet.forward.request_uri";
    private static final String JAVAX_SERVLET_FORWARD_QUERY_STRING = "javax.servlet.forward.query_string";
    private static final String UTF_8 = "UTF-8";
    private static final String TENANT_DOMAIN = "tenant-domain";

    String recoveryEPAvailable = application.getInitParameter("EnableRecoveryEndpoint");
    String enableSelfSignUpEndpoint = application.getInitParameter("EnableSelfSignUpEndpoint");
    Boolean isRecoveryEPAvailable = false;
    Boolean isSelfSignUpEPAvailable = false;
    String identityMgtEndpointContext = "";
    String urlEncodedURL = "";
    String urlParameters = "";

    if (StringUtils.isNotBlank(recoveryEPAvailable)) {
        isRecoveryEPAvailable = Boolean.valueOf(recoveryEPAvailable);
    } else {
        isRecoveryEPAvailable = isRecoveryEPAvailable();
    }

    if (StringUtils.isNotBlank(enableSelfSignUpEndpoint)) {
        isSelfSignUpEPAvailable = Boolean.valueOf(enableSelfSignUpEndpoint);
    } else {
        isSelfSignUpEPAvailable = isSelfSignUpEPAvailable();
    }

    if (isRecoveryEPAvailable || isSelfSignUpEPAvailable) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String uri = (String) request.getAttribute(JAVAX_SERVLET_FORWARD_REQUEST_URI);
        String prmstr = URLDecoder.decode(((String) request.getAttribute(JAVAX_SERVLET_FORWARD_QUERY_STRING)), UTF_8);
        String urlWithoutEncoding = scheme + "://" +serverName + ":" + serverPort + uri + "?" + prmstr;

        urlEncodedURL = URLEncoder.encode(urlWithoutEncoding, UTF_8);
        urlParameters = prmstr;

        identityMgtEndpointContext =
                application.getInitParameter("IdentityManagementEndpointContextURL");
        if (StringUtils.isBlank(identityMgtEndpointContext)) {
            identityMgtEndpointContext = getServerURL("/accountrecoveryendpoint", true, true);
        }
    } 
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <link rel="stylesheet" href="./css/login.css" />
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
    <title>Pantalla &Uacute;nica | Cuenta Cr&eacute;dito</title>
  </head>
  <body onload="checkSessionKey()">
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
          <h3>Inicia sesi&oacute;n</h3>
          <div class="form__group field">
            <input
              type="text"
              class="form__field"
              placeholder="Usuario o correo electr&oacute;nico *"
              name="username"
              id="username"
            />
            <label for="name" class="form__label"
              >Usuario o correo electr&oacute;nico *</label
            >
          </div>
          <div class="form__group field">
            <input
              type="password"
              class="form__field"
              placeholder="Contrase&ntilde;a *"
              name="password"
              id="password"
            />
            <label for="name" class="form__label">Contrase&ntilde;a *</label>
            <i class="bi bi-eye-slash" id="togglePassword"></i>
          </div>
          <input type="hidden" name="sessionDataKey" value="<%=Encode.forHtmlAttribute(request.getParameter("sessionDataKey"))%>"/>
          <button type="button" class="button-form" id="btnSubmit">
            Iniciar sesi&oacute;n
          </button>
        </form>

        <%!
        private String getRecoverAccountUrl (
            String identityMgtEndpointContext,
            String urlEncodedURL,
            boolean isUsernameRecovery,
            String urlParameters) {

            return identityMgtEndpointContext + "/recoveraccountrouter.do?" + urlParameters +
                "&isUsernameRecovery=" + isUsernameRecovery + "&callback=" + Encode.forHtmlAttribute(urlEncodedURL);
        }

        private String getRegistrationUrl (
            String identityMgtEndpointContext,
            String urlEncodedURL,
            String urlParameters) {

            return identityMgtEndpointContext + "/register.do?" + urlParameters +
                "&callback=" + Encode.forHtmlAttribute(urlEncodedURL);
        }
    %>

        <a id="passwordRecoverLink" tabindex="6" href="<%=getRecoverAccountUrl(identityMgtEndpointContext, urlEncodedURL, false, urlParameters)%>">
            Recuperar contraseña
        </a>
      </div>
    </div>
  </body>
  <script src="./js/login.js"></script>
</html>
