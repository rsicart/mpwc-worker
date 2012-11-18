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

<%@include file="/jsp/init.jsp" %>
 
 <%
 locale = request.getLocale();
 String language = locale.getLanguage();
 String country = locale.getCountry();

 ResourceBundle res = ResourceBundle.getBundle("content.Language-ext", new Locale(language, country));
 
 long groupId = themeDisplay.getLayout().getGroupId();
 //portlet permissions
 String namePortlet = portletDisplay.getId(); //default value
 String primKeyPortlet = "workerportlet"; //portlet name
 
 //portlet actions available (see resource-actions/default.xml)
 String permAddWorker = "ADD_WORKER";
 String permUpdateWorker = "UPDATE_WORKER";
 String permDeleteWorker = "DELETE_WORKER";
 
 //get search filters if necessary
 String ftrDesc = "";
 String ftrNif = "";
 String ftrName = "";
 String ftrSurname = "";
 String ftrEmail = "";
 String ftrPhone = "";
 
 Enumeration<String> sessionParams = request.getSession().getAttributeNames();
 while(sessionParams.hasMoreElements()){
	 String attributeName = (String) sessionParams.nextElement();
	 String decodedName = PortletSessionUtil.decodeAttributeName(attributeName);
	 if(decodedName.equals("ftrDesc") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrDesc = (String)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrNif") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrNif = (String)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrName") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrName = (String)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrSurname") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrSurname = (String)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrEmail") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrEmail = (String)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrPhone") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrPhone = (String)session.getAttribute(attributeName);
	 }
 }
 
 
 String error2 = "";
 try{
	 %>
	
	<portlet:renderURL var="addWorkerURL">
	   <portlet:param name="mvcPath" value="/jsp/add_from_user.jsp" />
	</portlet:renderURL>
	
	<portlet:actionURL var="filterURL" name="getWorkersByFilters">
	   <portlet:param name="mvcPath" value="/jsp/view.jsp" />
	</portlet:actionURL>
	
	<aui:form name="frm_list_workers" action="<%= filterURL %>" method="post">
	
		<aui:input type="hidden" name="redirectURL" value="<%= renderResponse.createRenderURL().toString() %>"/>
			
		<aui:layout>
		
		<aui:column columnWidth="20" first="true">
		
		<aui:fieldset>
		
			<aui:input label='<%= res.getString("formlabel.name") %>' id="ftrname" name="ftrname" type="text" value="<%= ftrName %>">
				<!-- Only allow alphabetical characters -->
	     		<aui:validator name="alpha" />
			</aui:input>
	
		    <aui:input label='<%= res.getString("formlabel.surname") %>' id="ftrsurname" name="ftrsurname" type="text" value="<%= ftrSurname %>">
				<!-- Only allow alphabetical characters -->
	     		<aui:validator name="alpha" />
		    </aui:input>
		    
		</aui:fieldset>
		
		</aui:column>
		
		<aui:column columnWidth="20">
		<aui:fieldset>
			<aui:input label='<%= res.getString("formlabel.phone") %>' id="ftrphone" name="ftrphone" type="text" value="<%= ftrPhone %>" >
				<!-- Only allow numeric format -->
	     		<aui:validator name="digits" />
			</aui:input>
			
		    <aui:input label='<%= res.getString("formlabel.nif") %>' id="ftrnif" name="ftrnif" type="text" value="<%= ftrNif %>" >
				<!-- Only allow alphabetical characters -->
	     		<aui:validator name="alphanum" />	     		
			</aui:input>
			
		</aui:fieldset>
		</aui:column>

		<aui:column columnWidth="60" last="true">
		<aui:fieldset>
		    <aui:input label='<%= res.getString("formlabel.email") %>' id="ftremail" name="ftremail" type="text" value="<%= ftrEmail %>" >
				<!-- Only allow email format -->
	     		<aui:validator name="email" />
			</aui:input>
			
			<aui:button type="submit" id="btn_filter" value='<%= res.getString("formlabel.actionfilter") %>' />
					
		</aui:fieldset>
		</aui:column>
			
	</aui:layout>
	
	</aui:form>
	
	<aui:layout>
	
	<aui:column columnWidth="80" first="true">
	
	<!-- grid -->
	 
	<liferay-ui:search-container delta="5">
	
	<liferay-ui:search-container-results>
	<% 
		List<Worker> tempResults = WorkerLocalServiceUtil.getWorkersByFilters(ftrDesc, ftrNif, ftrName, ftrSurname, ftrEmail, ftrPhone);
		results = ListUtil.subList(tempResults, searchContainer.getStart(),searchContainer.getEnd());
		total = tempResults.size();
		pageContext.setAttribute("results", results);
		pageContext.setAttribute("total",total);
	 %>	
	 </liferay-ui:search-container-results>
	 
	 <liferay-ui:search-container-row className="com.mpwc.model.Worker" keyProperty="workerId" modelVar="worker">
	 	<liferay-ui:search-container-column-text name="Name" property="name" />
	 	<liferay-ui:search-container-column-text name="Surame" property="surname" />
	 	<liferay-ui:search-container-column-text name="Nif" property="nif" />
	 	<liferay-ui:search-container-column-text name="Email" property="email" />
	 	<liferay-ui:search-container-column-jsp path="/jsp/list_actions.jsp" align="right" />
	 </liferay-ui:search-container-row>
	 
	 <liferay-ui:search-iterator />
	 
	 </liferay-ui:search-container>
	 
	 <!-- end grid -->
 	
 	</aui:column>	
 	
 	</aui:layout>
 	
 	<aui:layout>	
 	
 	<aui:column columnWidth="20" last="true">
 	
 		<aui:form name="frm_add_workers" action="<%= addWorkerURL %>" method="post">
 	
	 	<aui:fieldset>
	 	
	 	<c:if test="<%= permissionChecker.hasPermission(groupId, namePortlet, primKeyPortlet, permAddWorker) %>">
	 		<aui:button type="submit" id="btn_add" value='<%= res.getString("formlabel.actionadd") %>' inlineField="false" />
	 	</c:if> 	
	 	
	 	</aui:fieldset>
	 	
	 	</aui:form>	
 	
 	</aui:column>
 	
 	</aui:layout>	

	 <%
 } catch (Exception e2) {
		error2 = e2.getMessage();
		System.out.println("Error2 view.jsp: "+error2);
 }
%>