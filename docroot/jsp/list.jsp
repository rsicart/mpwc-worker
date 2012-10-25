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
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="javax.portlet.PortletPreferences" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.util.Locale" %>

 <portlet:resourceURL id="getWorkersByFiltersJSON" var="jqGridResourceURL"></portlet:resourceURL>
 
 <portlet:resourceURL var="jqGridFormResourceURL">
 	<portlet:param name="jspPage" value="/jsp/list.jsp"></portlet:param>
 </portlet:resourceURL>
 
 <portlet:defineObjects />
 
 <%
 Locale locale = request.getLocale();
 String language = locale.getLanguage();
 String country = locale.getCountry();

 ResourceBundle res = ResourceBundle.getBundle("content.Language-ext", new Locale(language, country));
 %>
 
 <script type="text/javascript">
 jQuery.jgrid.no_legacy_api = true;
 jQuery.jgrid.useJSON = true;
 </script>


	<portlet:renderURL var="addNewWorkerCheckbox">
	   <portlet:param name="mvcPath" value="/jsp/add.jsp" />
	</portlet:renderURL>	
	<portlet:renderURL var="editWorkerCheckbox">
	    <portlet:param name="mvcPath" value="/jsp/edit.jsp" />
	</portlet:renderURL>
	<portlet:renderURL var="deleteWorkerCheckbox">
	    <portlet:param name="mvcPath" value="/jsp/delete.jsp" />
	</portlet:renderURL>
	<portlet:actionURL var="deleteWorkersURL" name="deleteWorkers">
	    <portlet:param name="mvcPath" value="/jsp/list.jsp" />
	</portlet:actionURL>
	
	<aui:form name="frm_list_workers" action="" method="post">
	
		<aui:input type="hidden" name="redirectURL" value="<%= renderResponse.createRenderURL().toString() %>"/>
		<input type="hidden" id="workerId" name="workerId" value="" />
		<input type="hidden" id="jsonWorkerIds" name="jsonWorkerIds" value="" />
		
		
		<aui:layout>
		
		<aui:column columnWidth="20" first="true">
		
		<aui:fieldset>
		
			<aui:input label='<%= res.getString("formlabel.name") %>' id="ftrname" name="ftrname" type="text" value="">
				<!-- Only allow alphabetical characters -->
	     		<aui:validator name="alpha" />
			</aui:input>
	
		    <aui:input label='<%= res.getString("formlabel.surname") %>' id="ftrsurname" name="ftrsurname" type="text" value="">
				<!-- Only allow alphabetical characters -->
	     		<aui:validator name="alpha" />
		    </aui:input>
		    
		</aui:fieldset>
		
		</aui:column>
		
		<aui:column columnWidth="20">
		<aui:fieldset>
			<aui:input label='<%= res.getString("formlabel.phone") %>' id="ftrphone" name="ftrphone" type="text" value="" >
				<!-- Only allow numeric format -->
	     		<aui:validator name="digits" />
			</aui:input>
			
		    <aui:input label='<%= res.getString("formlabel.nif") %>' id="ftrnif" name="ftrnif" type="text" value="" >
				<!-- Only allow alphabetical characters -->
	     		<aui:validator name="alphanum" />	     		
			</aui:input>
			
		</aui:fieldset>
		</aui:column>

		<aui:column columnWidth="60" last="true">
		<aui:fieldset>
		    <aui:input label='<%= res.getString("formlabel.email") %>' id="ftremail" name="ftremail" type="text" value="" >
				<!-- Only allow email format -->
	     		<aui:validator name="email" />
			</aui:input>
			
			<aui:button type="button" id="btn_filter" value='<%= res.getString("formlabel.actionfilter") %>' />
					
		</aui:fieldset>
		</aui:column>
		
	</aui:layout>
	
	<aui:layout>
	
	<aui:column columnWidth="80" first="true">
		
		<!-- Grid begin -->
		<table id="list1"></table>
		<div id="pager1"></div>
		<table id="navgrid"></table>
		<div id="pagernav"></div>
		<!-- Grid end -->
 	
 	</aui:column>
 	
 	<aui:column columnWidth="20" last="true">
 	
	 	<aui:fieldset>

	 	<aui:button type="submit" id="btn_add" value='<%= res.getString("formlabel.actionadd") %>' inlineField="false" />
	 	<aui:button type="submit" id="btn_edit" value='<%= res.getString("formlabel.actionedit") %>' inlineField="false" />	 	
	 	<aui:button type="submit" id="btn_delete" value='<%= res.getString("formlabel.actiondelete") %>' inlineField="false" />
	 	
	 	</aui:fieldset>
 	
 	</aui:column>
 	
 	</aui:layout>
 	
 	</aui:form>


 <script>
 jQuery("#list1").jqGrid({
     url:'<%=jqGridResourceURL.toString()%>',
 	 datatype: "json",
     colNames:['WorkerId', '<%= res.getString("formlabel.name") %>', '<%= res.getString("formlabel.surname") %>','<%= res.getString("formlabel.email") %>','<%= res.getString("formlabel.nif") %>','<%= res.getString("formlabel.status") %>'],
     colModel:[
      {name:'id',index:'id', width:60, sorttype:"int"},
      {name:'name',index:'name', width:100},
      {name:'surname',index:'surname', width:100, align:"right"},
      {name:'email',index:'email', width:150, align:"right"},  
      {name:'nif',index:'nif', width:60, align:"right"},  
      {name:'status',index:'status', width:40}  
     ],
     multiselect: true,
     rowNum:20,
     rowList:[10,20,30],
     pager: '#pager1',
     sortname: 'id',
     viewrecords: true,
     sortorder: "desc",
     onSelectRow: function(id){
 			jQuery("#workerId").value = id;
 	 },
     loadonce: false,
     caption: "<%= res.getString("jspview.maintitle") %>"
 });
 jQuery("#list1").jqGrid('navGrid','#pager1',
  {edit:false,add:false,del:false,search:false},
  {},
  {},
  {},
  {multipleSearch:false, multipleGroup:false}
  );
 
 //////buttons
 //add
 jQuery("#btn_add").click( function(){
	 var fullid = "#<%= renderResponse.getNamespace() %>"+"frm_list_workers";
	 $(fullid).attr("action","<%= addNewWorkerCheckbox %>");
	 
 });
 
 //edit
 jQuery("#btn_edit").click( function(){
	 var myGrid = $('#list1'),
	 selRowId = myGrid.jqGrid ('getGridParam', 'selrow'),
	 celValue = myGrid.jqGrid ('getCell', selRowId, 'id');
	 $('#workerId').val(celValue);
	 
	 var fullid = "#<%= renderResponse.getNamespace() %>"+"frm_list_workers";
	 $(fullid).attr("action","<%= editWorkerCheckbox %>");	 
 });
 
 //delete
 jQuery("#btn_delete").click( function(){
	 var myGrid = $('#list1'),
	 selArrRowIds = "["+myGrid.getGridParam('selarrrow')+"]";
	 $('#jsonWorkerIds').val(selArrRowIds);
	 if( confirm("<%= res.getString("jspview.dialog.areyouusure") %>") ){
		 var fullid = "#<%= renderResponse.getNamespace() %>"+"frm_list_workers";
		 $(fullid).attr("action","<%= deleteWorkersURL %>"); 
	 }	 
 });

 //filter
 jQuery("#btn_filter").click( function(){
	//var ftrDesc = $('#<portlet:namespace/>ftrdesc').val();
	var ftrNif = $('#<portlet:namespace/>ftrnif').val();
	var ftrName = $('#<portlet:namespace/>ftrname').val();
	var ftrSurname = $('#<portlet:namespace/>ftrsurname').val();
	var ftrEmail = $('#<portlet:namespace/>ftremail').val();
	var ftrPhone = $('#<portlet:namespace/>ftrphone').val();
	
	//var params = '&desc='+ftrDesc+'&nif='+ftrNif+'&name='+ftrName+'&surname='+ftrSurname+'&email='+ftrEmail+'&phone='+ftrPhone;
	var params = '&nif='+ftrNif+'&name='+ftrName+'&surname='+ftrSurname+'&email='+ftrEmail+'&phone='+ftrPhone;
	
	//alert(params);
	
	$('#list1').setGridParam({ 
		 url: '<%=jqGridResourceURL.toString()%>'+params, 
	});
	$('#list1').trigger("reloadGrid"); 	 
 });

 </script>