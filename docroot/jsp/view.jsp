<!--  
/*

Copyright (c) 2012 Roger Sicart. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    (1) Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer. 

    (2) Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.  
    
    (3)The name of the author may not be used to
    endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
 
 */

/*
 * @author R.Sicart
 */
-->

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ page import="com.mpwc.model.Worker" %>
<%@ page import="com.mpwc.service.WorkerLocalServiceUtil" %>
<%@page import="com.mpwc.service.persistence.WorkerUtil"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.util.Locale" %>

<portlet:defineObjects />

<%
 Locale locale = request.getLocale();
 String language = locale.getLanguage();
 String country = locale.getCountry();

 ResourceBundle res = ResourceBundle.getBundle("content.Language-ext", new Locale(language, country));

 String error = "";
 List<Worker> ls;
 try{
	Integer n = WorkerLocalServiceUtil.getWorkersCount();
 	ls = WorkerLocalServiceUtil.getWorkers(0, n);
 	ls = WorkerLocalServiceUtil.findByStatus(1);
 	//TODO: get only non deleted workers 
 	
 	%>
 	<p><b><%= res.getString("jspview.maintitle") %></b></p>
 	<% 
 	if (n == 0){
 	%>
		<portlet:renderURL var="addWorkerURL">
		    <portlet:param name="mvcPath" value="/jsp/add.jsp" />
		</portlet:renderURL>	
		<p><%= res.getString("jspview.message.noworkers") %> <a href="<%= addWorkerURL %>"> <%= res.getString("jspview.message.addoneworker") %> </a></p>
 	<%
 	}
 	else{
 	%>
 		<portlet:renderURL var="addNewWorkerCheckbox">
		    <portlet:param name="mvcPath" value="/jsp/add.jsp" />
		</portlet:renderURL>	
	 	<portlet:renderURL var="editWorkerCheckbox">
			    <portlet:param name="mvcPath" value="/jsp/edit.jsp" />
		</portlet:renderURL>
		<portlet:renderURL var="deleteWorkerCheckbox">
			    <portlet:param name="mvcPath" value="/jsp/delete.jsp" />
		</portlet:renderURL>
	 	
	 	<script type="text/javascript">
	 		function onAdd(){
				var fullid = "<%= renderResponse.getNamespace() %>"+"frm_list_workers";
	 			document.getElementById(fullid).action="<%= addNewWorkerCheckbox %>";
	 		} 	
	 		function onEdit(){
				var fullid = "<%= renderResponse.getNamespace() %>"+"frm_list_workers";
	 			document.getElementById(fullid).action="<%= editWorkerCheckbox %>";
	 		}
	 		function onDelete(){
				var fullid = "<%= renderResponse.getNamespace() %>"+"frm_list_workers";
	 			document.getElementById(fullid).action="<%= deleteWorkerCheckbox %>";
	 		}
	 	</script>
 	
 		<aui:form name="frm_list_workers" action="" method="post">
 		
 		<aui:layout>
 		
 		<aui:column columnWidth="90" first="true">
 		
	 	<table border="1" width="80%">
	 	<tr class="portlet-section-header">
	 		<td><b></b></td>
	 		<td><b> <%= res.getString("formlabel.name") %> </b></td>
	 		<td><b> <%= res.getString("formlabel.surname") %></b></td>
	 		<td><b> <%= res.getString("formlabel.nif") %></b></td>
	 		<td><b> <%= res.getString("formlabel.email") %> </b></td>
	 		<td><b> <%= res.getString("formlabel.phone") %></b></td>
	 		<td><b> <%= res.getString("formlabel.status") %></b></td>
	 	</tr>
	 	<%
	 	for(Worker w: ls){
	 		%>

 		<tr class="portlet-section-body">
 			<td><input type="checkbox" name="workerId" value="<%= String.valueOf( w.getWorkerId() ) %>" /></td>
 			<td> <%= w.getName() %></td> 
 			<td> <%= w.getSurname() %></td> 
 			<td> <%= w.getNif() %></td>
 			<td> <%= w.getEmail() %></td>
 			<td> <%= w.getPhone() %></td>
 			<td> <%= w.getStatus() %></td>
 		</tr>
	 		<%
	 	}
	 	%>
	 	</table>
	 	
	 	</aui:column>
	 	
	 	<aui:column columnWidth="10" last="true">
	 	
		 	<aui:fieldset>
		 	
		 	<aui:button type="submit" value='<%= res.getString("formlabel.actionadd") %>' onClick='onAdd();' />
		 	<aui:button type="submit" value='<%= res.getString("formlabel.actionedit") %>' onClick='onEdit();' />	 	
		 	<aui:button type="submit" value='<%= res.getString("formlabel.actiondelete") %>' onClick='onDelete();' />
		 	
		 	</aui:fieldset>
	 	
	 	</aui:column>
	 	
	 	</aui:layout>
	 	
	 	</aui:form>
	 	
	<portlet:renderURL var="listURL">
	    <portlet:param name="mvcPath" value="/jsp/list.jsp" />
	</portlet:renderURL>
	
	<p><a href="<%= listURL %>">&larr; List</a></p>
	 	
 	<%
 	}
 } catch (Exception e) {
	error = e.getMessage();
	System.out.println("Error view.jsp: "+error);
 }
%>
