
<%@ include file="./common/header.jsp" %>
<div class="container" style="width:700px; height:500px;margin-top:100px; border:1px solid gray;padding-top:50px">
  <h1 style="text-align:center">Login Page</h1>
  <h2><c:out value="${error}"/></h2>
  <h2><c:out value="${logout}"/></h2>
  
  <form class="m-5" method='post' action="${contextPath}/login">
  
  <div class="form-group">
  	<label class="col-sm-2 col-form-label">id</label>
    <input class="form-control" type='text' name='username'>
  </div>
  <div class="form-group">
  	<label class="col-sm-2 col-form-label">password</label>
    <input class="form-control" type='password' name='password'>
  </div>
  <div class="form-group">
  	<input type="checkbox" name="remember-me"> Remember Me
  </div>  
  
  <div style="text-align:center">
    <input class="btn btn-secondary" type='submit' value="Login">
  </div>
    <input type="hidden" name="${_csrf.parameterName}"
    value="${_csrf.token}" />
  
  </form>
</div>
</body>
</html>