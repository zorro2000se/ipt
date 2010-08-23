<#include "/WEB-INF/pages/inc/header.ftl">
<script type="text/javascript">
	var DATE_RANGE = "DATE_RANGE";
	var FORMATION_PERIOD = "FORMATION_PERIOD";
	var LIVING_TIME_PERIOD = "LIVING_TIME_PERIOD";
	var SINGLE_DATE = "SINGLE_DATE";
	var count;
	// a function called when adding new temporal coverages
	// an element is cloned and the IDs reset etc etc
	$(document).ready(function() {	
		initHelp();
		calculateCount();
		
		function calculateCount() {
			var lastChild = $("#temporals .tempo:last-child").attr("id");
			if(lastChild != undefined) {
				count = parseInt(lastChild.split("-")[1])+1;
			} else {
				count = new Number(0);
			}
		}
		
		$("#plus").click(function(event) {
			event.preventDefault();
			var idNewForm = "temporal-"+count;
			var newForm = $("#temporal-99999").clone().attr("id", idNewForm).css('display', '');
			// Add the fields depending of the actual value in the select
			var typeSubForm = $("#tempTypes").attr("value");			
			
			//Adding the 'sub-form' to the new form.
			addTypeForm(newForm, typeSubForm, true);			
			
			$("#temporals").append(newForm);	
			
			// This should be in a method
			updateFields(idNewForm, count);			
			// end method
			
			$("#temporal-"+count).hide().slideDown("slow");
			count++;
		});
		
		/**
		 * This method a new subform to the form that is in the parameter.
		 */
		function addTypeForm(theForm, typeSubForm, changeDisplay) {
			var newSubForm;
			if(typeSubForm == DATE_RANGE) {
				newSubForm = $("#date-99999").clone(true);				
			}
			if(typeSubForm == FORMATION_PERIOD) {
				newSubForm = $("#formation-99999").clone(true);	
			}
			if(typeSubForm == LIVING_TIME_PERIOD) {
				newSubForm = $("#living-99999").clone(true);
			}
			if(typeSubForm == SINGLE_DATE) {				
				newSubForm = $("#single-99999").clone(true);
			}
			if(changeDisplay) {
				newSubForm.css("display", "");
			}
			theForm.append(newSubForm);
		}
		
		/**
		 * this method update the name and the id of the form to the consecutive number in the parameter.
		 */
		function updateFields(idNewForm, index) {
			$("#"+idNewForm+" .removeLink").attr("id", "removeLink-"+index)
			
			// Remove Link (registering the event for the new links).
			$("#"+idNewForm+" .removeLink").click(
				function(event) {
					event.preventDefault();					
					removeTemporal(event);
				}
			);
			// Select ==> tempTypes
			$("#"+idNewForm+" [id^='tempTypes']").attr("id", "tempTypes-"+index).attr("name", function() {return $(this).attr("id");});
			
			// Update the fields depending of the actual value in the select
			var typeSubForm = $("#"+idNewForm+" #tempTypes-"+index).attr("value");
			
			// Registering the event for the new selects.
			$("#"+idNewForm+" #tempTypes-"+count).change(
				function() {		
					changeForm($(this));
				}
			);			
			
			if(typeSubForm == DATE_RANGE) {
				$("#"+idNewForm+" [id^='date-']").attr("id", "date-"+index);
				$("#"+idNewForm+" [id$='startDate']").attr("id", "eml.temporalCoverages["+index+"].startDate").attr("name", function() {return $(this).attr("id");});
				$("#"+idNewForm+" [id$='endDate']").attr("id", "eml.temporalCoverages["+index+"].endDate").attr("name", function() {return $(this).attr("id");});
			}
			if(typeSubForm == FORMATION_PERIOD) {
				$("#"+idNewForm+" [id^='formation-']").attr("id", "formation-"+index);
				$("#"+idNewForm+" [id$='formationPeriod']").attr("id", "eml.temporalCoverages["+index+"].formationPeriod").attr("name", function() {return $(this).attr("id");});								
			}
			if(typeSubForm == LIVING_TIME_PERIOD) {				
				$("#"+idNewForm+" [id^='living-']").attr("id", "living-"+index);
				$("#"+idNewForm+" [id$='livingTimePeriod']").attr("id", "eml.temporalCoverages["+index+"].livingTimePeriod").attr("name", function() {return $(this).attr("id");});								
			}
			if(typeSubForm == SINGLE_DATE) {				
				$("#"+idNewForm+" [id^='single-']").attr("id", "single-"+index);
				$("#"+idNewForm+" [id$='startDate']").attr("id", "eml.temporalCoverages["+index+"].startDate").attr("name", function() {return $(this).attr("id");});				
			}
		}
		
		// This event should work for the temporal coverage that already exist in the file.
		$("#tempTypes").change(function(event) {
			changeForm($(this));
		});
		
		function changeForm(select) {
			var selection = select.attr("value");
			var index = select.attr("id").split("-")[1];				
			$("#temporal-"+index+" .typeForm").fadeOut(function() {
				$(this).remove();				
				addTypeForm($("#temporal-"+index), selection, false);
				$("#temporal-"+index+" .typeForm").fadeIn(function() {
					updateFields("temporal-"+index, index);
				});
			});
			
						
		}
		
		// This event should work for the temporal coverage that already exist in the file.
		$(".removeLink").click(function(event) {
			event.preventDefault();
			removeTemporal(event);
		});

		function removeTemporal(event) {
			var $target = $(event.target);
			var index = $target.attr("id").split("-")[1];									
			// removing the form in the html.
			//$("#toRemove").slideUp("slow", function() {
			$('#temporal-'+index).slideUp("slow", function() {
				$(this).remove();
				$("#temporals .tempo").each(function(index) { 
					updateFields($(this).attr("id"), index);
					$(this).attr("id", "temporal-"+index);
				});
				calculateCount();
			} );
		}
		
		
	});
</script>

<title><@s.text name='manage.metadata.tempcoverage.title'/></title>
<#assign sideMenuEml=true />
<#include "/WEB-INF/pages/inc/menu.ftl">

<h1><@s.text name='manage.metadata.tempcoverage.title'/>: <em>${ms.resource.title!ms.resource.shortname}</em></h1>
<p><@s.text name='manage.metadata.tempcoverage.intro'/></p>

<#include "/WEB-INF/pages/macros/forms.ftl"/>

<form class="topForm" action="metadata-${section}.do" method="post">
	<div id="temporals">




	</div>
	
	<!-- The add link and the buttons should be first. The next div is hidden. -->
	<a id="plus" href="" ><@s.text name='manage.metadata.addnew' /> <@s.text name='manage.metadata.tempcoverage.item' /></a>
	<div class="buttons">
		<@s.submit name="save" key="button.save"/>
		<@s.submit name="cancel" key="button.cancel"/>
	</div>
	<div class="horizontal_dotted_line_large_foo" id="separator"></div>
	<div class="horizontal_dotted_line_large_foo" id="separator"></div>
	<div class="horizontal_dotted_line_large_foo" id="separator"></div>
	<div class="newline"></div>
	<div class="newline"></div>
	
	
</form>

<!-- The base form that is going to be cloned every time an user clic in the 'add' link -->
<div id="temporal-99999" class="tempo" style="display:none">
	<div class="right">		
		<a id="removeLink" class="removeLink" href="">[ <@s.text name='manage.metadata.removethis'/> <@s.text name='manage.metadata.tempcoverage.item'/> ]</a>
	</div>
	<div class="newline"></div>	
	<@select i18nkey="eml.temporalCoverage.type"  name="tempTypes" options=tempTypes value="value" />  
	<div class="newline"></div>	
</div>

<!-- DATE RANGE -->
<div id="date-99999" class="typeForm" style="display:none">
	<div class="half">
		<@input i18nkey="eml.temporalCoverage.startDate" name="startDate" help="i18n"/>
		<@input i18nkey="eml.temporalCoverage.endDate" name="endDate" help="i18n"/>
	</div>		  
	<div class="newline"></div>      
	<div class="horizontal_dotted_line_large_foo" id="separator"></div>
	<div class="newline"></div>
	<div class="newline"></div>
</div>

<!-- SINGLE DATE -->
<div id="single-99999" class="typeForm" style="display:none">
	<div class="half">
		<@input i18nkey="eml.temporalCoverage.startDate" name="startDate" help="i18n"/>
	</div>
	<div class="newline"></div>
	<div class="horizontal_dotted_line_large_foo" id="separator"></div>
	<div class="newline"></div>
	<div class="newline"></div>
</div>

<!-- FORMATION PERIOD -->
<div id="formation-99999" class="typeForm" style="display:none">
	<div class="half">
		<@input i18nkey="eml.temporalCoverage.formationPeriod" name="formationPeriod" />
	</div>
	<div class="newline"></div>
	<div class="horizontal_dotted_line_large_foo" id="separator"></div>
	<div class="newline"></div>
	<div class="newline"></div>
</div>

<!-- LIVING TIME PERIOD -->
<div id="living-99999" class="typeForm" style="display:none">
	<div class="half">
		<@input i18nkey="eml.temporalCoverage.livingTimePeriod" name="livingTimePeriod" />
	</div>
	<div class="newline"></div>
	<div class="horizontal_dotted_line_large_foo" id="separator"></div>
	<div class="newline"></div>
	<div class="newline"></div>
</div>

<#include "/WEB-INF/pages/inc/footer.ftl">