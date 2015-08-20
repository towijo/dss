<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<h2>
    <spring:message code="label.tsls" />
</h2>

<jsp:useBean id="now" class="java.util.Date"/>

<c:forEach var="validation" items="${mapValidations}">
    <c:set var="countryCode" value="${validation.key}" />
    <c:set var="model" value="${validation.value}" />
    
	<c:set var="panelStyle" value="" />
    <c:choose>
        <c:when test="${model.validationResult != null && !model.validationResult.signatureValid}">
            <c:set var="panelStyle" value="panel-danger" />
        </c:when>
        <c:when test="${model.parseResult != null && model.parseResult.nextUpdateDate != null && model.parseResult.nextUpdateDate le now}">
            <c:set var="panelStyle" value="panel-warning" />
        </c:when>
        <c:otherwise>
            <c:set var="panelStyle" value="panel-success" />
        </c:otherwise>
    </c:choose>
    
    
    <div class="panel ${panelStyle}">
        <div class="panel-heading" data-toggle="collapse" data-target="#country${countryCode}">
            <h3 class="panel-title">${countryCode}</h3>
        </div>
        <div class="panel-body collapse in" id="country${countryCode}">
            <dl class="dl-horizontal">
                <dt>Url : </dt>
                <dd><a href="${model.url}">${model.url}</a></dd>

                <c:if test="${model.loadedDate !=null}">
                    <dt>Loaded date : </dt>
                    <dd><fmt:formatDate pattern="dd/MM/yyyy HH:mm:ss" value="${model.loadedDate}" /></dd>
                </c:if>
                
                <c:if test="${model.validationResult != null}">
                    <dt>Signature valid :</dt>
                    <dd>
                        <c:choose>
                            <c:when test="${model.validationResult.signatureValid}">
                                <span class="glyphicon glyphicon-ok-sign text-success"></span>
                            </c:when>
                            <c:otherwise>
                                <span class="glyphicon glyphicon-remove-sign text-danger"></span>
                            </c:otherwise>                            
                        </c:choose>
                    </dd>
                </c:if>
                
                <c:if test="${model.parseResult !=null}">
                    <dt>Sequence number :</dt>
                    <dd>${model.parseResult.sequenceNumber}</dd>
                    <dt>Issue date : </dt>
                    <dd><fmt:formatDate pattern="dd/MM/yyyy HH:mm:ss" value="${model.parseResult.issueDate}" /></dd>
                    <dt>Next update date : </dt>
                    <dd${model.parseResult.nextUpdateDate le now ? ' style="color:red"' : ''}><fmt:formatDate pattern="dd/MM/yyyy HH:mm:ss" value="${model.parseResult.nextUpdateDate}" /></dd>
                </c:if>
            </dl>
            
            <c:if test="${model.parseResult !=null && not empty model.parseResult.serviceProviders}">
                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" data-target="#countryServiceProviders${countryCode}${sp.index}">
                        <span class="badge pull-right">${fn:length(model.parseResult.serviceProviders)}</span>
                        <h3 class="panel-title">Trust service providers</h3>
                    </div>
                    <div class="panel-body collapse in" id="countryServiceProviders${countryCode}">
                        <c:forEach var="serviceProvider" items="${model.parseResult.serviceProviders}" varStatus="sp">
                            <dl class="dl-horizontal">
                                <dt>Name :</dt>
                                <dd>${serviceProvider.name}</dd>
                                <c:if test="${not empty serviceProvider.tradeName}">
                                    <dt>Trade name :</dt>
                                    <dd>${serviceProvider.tradeName}</dd>
                                </c:if>
                                <dt>Postal address :</dt>
                                <dd>${serviceProvider.postalAddress}</dd>
                                <dt>Electronic address :</dt>
                                <dd><a href="${serviceProvider.electronicAddress}" title="${serviceProvider.name}">${serviceProvider.electronicAddress}</a></dd>
                            </dl>
                            <c:if test="${not empty serviceProvider.services}">
                                <div class="panel panel-default">
                                    <div class="panel-heading" data-toggle="collapse" data-target="#countryServices${countryCode}${sp.index}">
                                        <span class="badge pull-right">${fn:length(serviceProvider.services)}</span>
                                        <h3 class="panel-title">Trust services</h3>
                                    </div>
                                    <div class="panel-body collapse in" id="countryServices${countryCode}${sp.index}">
                                        <c:forEach var="service" items="${serviceProvider.services}" varStatus="ser">
                                            <dl class="dl-horizontal">
                                                <dt>Name :</dt>
                                                <dd>${service.name}</dd>
                                                <dt>Status :</dt>
                                                <dd><a href="${service.status}">${service.status}</a></dd>
                                                <dt>Type :</dt>
                                                <dd><a href="${service.type}">${service.type}</a></dd>
                                                <dt>Start date :</dt>
                                                <dd><fmt:formatDate pattern="dd/MM/yyyy HH:mm:ss" value="${service.startDate}" /></dd>
                                                <c:if test="${service.endDate !=null}">
                                                    <dt>End date :</dt>
                                                    <dd><fmt:formatDate pattern="dd/MM/yyyy HH:mm:ss" value="${service.endDate}" /></dd>
                                                </c:if>
                                            </dl>
                                            
                                            <c:if test="${not empty service.certificates}">
                                                <div class="panel panel-default">
                                                    <div class="panel-heading" data-toggle="collapse" data-target="#countryCertificates${countryCode}${sp.index}-${ser.index}">
                                                        <span class="badge pull-right">${fn:length(service.certificates)}</span>
                                                        <h3 class="panel-title">Certificates</h3>
                                                    </div>
                                                    <div class="panel-body collapse in" id="countryCertificates${countryCode}${sp.index}-${ser.index}">
                                                        <c:forEach var="token" items="${service.certificates}">
                                                            <dl class="dl-horizontal">
                                                                <dt><spring:message code="label.service" /> :</dt>
                                                                <dd>${token.certificate.subjectDN.name}</dd>
                                                                <dt><spring:message code="label.issuer" /> :</dt>
                                                                <dd>${token.certificate.issuerDN.name}</dd>
                                                                <dt>Serial number</dt>
                                                                <dd>${token.serialNumber}</dd>
                                                                <dt><spring:message code="label.validity_start" /></dt>
                                                                <dd><fmt:formatDate pattern="dd/MM/yyyy HH:mm:ss" value="${token.certificate.notBefore}" /></dd>
                                                                <dt><spring:message code="label.validity_end" /></dt>
                                                                <dd><fmt:formatDate pattern="dd/MM/yyyy HH:mm:ss" value="${token.certificate.notAfter}" /></dd>
                                                            </dl>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${not empty service.x500Principals}">
                                                <div class="panel panel-default">
                                                    <div class="panel-heading" data-toggle="collapse" data-target="#countryx500Principals${countryCode}${sp.index}-${ser.index}">
                                                        <span class="badge pull-right">${fn:length(service.x500Principals)}</span>
                                                        <h3 class="panel-title">X509 Subject Names</h3>
                                                    </div>
                                                    <div class="panel-body collapse in" id="countryx500Principals${countryCode}${sp.index}-${ser.index}">
                                                        <c:forEach var="x500" items="${service.x500Principals}">
                                                            <dl class="dl-horizontal">
                                                                <dt><spring:message code="label.service" /> :</dt>
                                                                <dd>${x500.name}</dd>
                                                            </dl>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
            
            <c:if test="${model.parseResult !=null && not empty model.parseResult.pointers}">
                 <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" data-target="#countryPointers${countryCode}">
	                   <span class="badge pull-right">${fn:length(model.parseResult.pointers)}</span>
                        <h3 class="panel-title">Machine processable pointers</h3>
                    </div>
                    <div class="panel-body collapse in" id="countryPointers${countryCode}">
                        <ul>
                            <c:forEach var="item" items="${model.parseResult.pointers}">
                                <li><a href="${item.url}">${item.url}</a></li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</c:forEach>



<script type="text/javascript">
	$('.collapse').collapse();
</script>
