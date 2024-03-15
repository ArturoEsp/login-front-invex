<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.core.util.SignatureUtil" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.IdentityManagementEndpointConstants" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.client.ApiException" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.client.api.NotificationApi" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.client.model.Error" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.client.model.Property" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.client.model.ResetPasswordRequest" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.IdentityManagementEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.recovery.util.Utils" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.MalformedURLException" %>
<%@ page import="java.net.URISyntaxException" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="static java.util.stream.Collectors.toList" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="static java.util.stream.Collectors.groupingBy" %>
<%@ page import="static java.util.stream.Collectors.mapping" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:directive.include file="includes/localize.jsp"/>


<%!
    private static String decode(final String encoded) {
        try {
            return encoded == null ? null : URLDecoder.decode(encoded, "UTF-8");
        } catch(final UnsupportedEncodingException e) {
            throw new RuntimeException("Impossible: UTF-8 is a required encoding", e);
        }
    }
%>

<%
    String ERROR_MESSAGE = "errorMsg";
    String ERROR_CODE = "errorCode";
    String AUTO_LOGIN_COOKIE_NAME = "ALOR";
    String PASSWORD_RESET_PAGE = "password-reset.jsp";
    String passwordHistoryErrorCode = "22001";
    String passwordPatternErrorCode = "20035";
    String confirmationKey =
            IdentityManagementEndpointUtil.getStringValue(request.getSession().getAttribute("confirmationKey"));
    String newPassword = request.getParameter("reset-password");
    String callback = request.getParameter("callback");
    String tenantDomain = request.getParameter(IdentityManagementEndpointConstants.TENANT_DOMAIN);
    boolean isUserPortalURL = false;
    String sessionDataKey = request.getParameter("sessionDataKey");
    String username = request.getParameter("username");
    boolean isAutoLoginEnable = Boolean.parseBoolean(Utils.getConnectorConfig("Recovery.AutoLogin.Enable",
            tenantDomain));
    String USER_AGENT = "User-Agent";
    String userAgent = request.getHeader(USER_AGENT);
    String X_FORWARDED_USER_AGENT = "X-Forwarded-User-Agent";
    String SERVICE_PROVIDER = "serviceProvider";
    
    if (StringUtils.isBlank(callback)) {
        callback = IdentityManagementEndpointUtil.getUserPortalUrl(
                application.getInitParameter(IdentityManagementEndpointConstants.ConfigConstants.USER_PORTAL_URL));
    }

    if (callback.equals(IdentityManagementEndpointUtil.getUserPortalUrl(application
            .getInitParameter(IdentityManagementEndpointConstants.ConfigConstants.USER_PORTAL_URL)))) {
        isUserPortalURL = true;
    }
    
    if (StringUtils.isNotBlank(newPassword)) {
        NotificationApi notificationApi = new NotificationApi();
        ResetPasswordRequest resetPasswordRequest = new ResetPasswordRequest();
        
        List<Property> properties = new ArrayList<Property>();
        Property property = new Property();
        property.setKey("callback");
        property.setValue(URLEncoder.encode(callback, "UTF-8"));
        properties.add(property);

        Property userPortalURLProperty = new Property();
        userPortalURLProperty.setKey("isUserPortalURL");
        userPortalURLProperty.setValue(String.valueOf(isUserPortalURL));
        properties.add(userPortalURLProperty);

        Property tenantProperty = new Property();
        tenantProperty.setKey(IdentityManagementEndpointConstants.TENANT_DOMAIN);
        if (tenantDomain == null) {
            tenantDomain = IdentityManagementEndpointConstants.SUPER_TENANT;
        }
        tenantProperty.setValue(URLEncoder.encode(tenantDomain, "UTF-8"));
        properties.add(tenantProperty);
        Map<String, String> localVarHeaderParams = new HashMap<>();
        localVarHeaderParams.put(X_FORWARDED_USER_AGENT, userAgent);
        
        resetPasswordRequest.setKey(confirmationKey);
        resetPasswordRequest.setPassword(newPassword);
        resetPasswordRequest.setProperties(properties);
        
        try {
            URL url = new URL(URLDecoder.decode(callback, "UTF-8"));
            String query = url.getQuery();
            if (StringUtils.isNotBlank(query)) {
                Map<String, List<String>> queryMap =
                        Pattern.compile("&").splitAsStream(url.getQuery())
                                .map(s -> Arrays.copyOf(s.split("="), 2))
                                .collect(groupingBy(s -> decode(s[0]), mapping(s -> decode(s[1]), toList())));
                if (queryMap.containsKey("sp")) {
                    localVarHeaderParams.put(SERVICE_PROVIDER, queryMap.get("sp").get(0));
                }
            }
            notificationApi.setPasswordPost(resetPasswordRequest,localVarHeaderParams);
    
            if (isAutoLoginEnable) {
                String signature = Base64.getEncoder().encodeToString(SignatureUtil.doSignature(username));
                JSONObject cookieValueInJson = new JSONObject();
                cookieValueInJson.put("username", username);
                cookieValueInJson.put("signature", signature);
                Cookie cookie = new Cookie(AUTO_LOGIN_COOKIE_NAME,
                        Base64.getEncoder().encodeToString(cookieValueInJson.toString().getBytes()));
                cookie.setPath("/");
                cookie.setSecure(true);
                cookie.setMaxAge(300);
                response.addCookie(cookie);
            }
            
        } catch (ApiException | UnsupportedEncodingException | MalformedURLException e) {
            
            Error error = IdentityManagementEndpointUtil.buildError(e);
            IdentityManagementEndpointUtil.addErrorInformation(request, error);
            if (error != null) {
                request.setAttribute(ERROR_MESSAGE, error.getDescription());
                request.setAttribute(ERROR_CODE, error.getCode());
                if (passwordHistoryErrorCode.equals(error.getCode()) ||
                        passwordPatternErrorCode.equals(error.getCode())) {
                    String i18Resource = IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, error.getCode());
                    if (!i18Resource.equals(error.getCode())) {
                        request.setAttribute(ERROR_MESSAGE, i18Resource);
                    }
                    request.setAttribute(IdentityManagementEndpointConstants.TENANT_DOMAIN, tenantDomain);
                    request.setAttribute(IdentityManagementEndpointConstants.CALLBACK, callback);
                    request.getRequestDispatcher(PASSWORD_RESET_PAGE).forward(request, response);
                    return;
                }
            }
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

    } else {
        request.setAttribute("error", true);
        request.setAttribute("errorMsg", IdentityManagementEndpointUtil.i18n(recoveryResourceBundle,
                "Password.cannot.be.empty"));
        request.getRequestDispatcher("password-reset.jsp").forward(request, response);
        return;
    }

    session.invalidate();
%>

<!doctype html>
<html>
<head>
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
    <title>Contraseña actualizada | INVEX</title>
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
          <h3 class="text-aling-center ">Tu contraseña ha sido actualizada satisfactoriamente.</h3>
            <a href="<%= IdentityManagementEndpointUtil.getURLEncodedCallback(callback)%>" class="button-form" id="closeButton">
                Iniciar sesión
            </a>
        </div>
      </div>
</body>
</html>
