<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/asset_publisher/init.jsp" %>
<%@ page import="com.liferay.portlet.journal.service.JournalArticleResourceLocalServiceUtil" %>
<%@ page import="com.liferay.portlet.journal.model.JournalArticleResource" %>

<%@ page contentType="text/html; charset=UTF-8" %>

<%
List results = (List)request.getAttribute("view.jsp-results");

int assetEntryIndex = ((Integer)request.getAttribute("view.jsp-assetEntryIndex")).intValue();

AssetEntry assetEntry = (AssetEntry)request.getAttribute("view.jsp-assetEntry");
AssetRendererFactory assetRendererFactory = (AssetRendererFactory)request.getAttribute("view.jsp-assetRendererFactory");
AssetRenderer assetRenderer = (AssetRenderer)request.getAttribute("view.jsp-assetRenderer");

boolean show = ((Boolean)request.getAttribute("view.jsp-show")).booleanValue();

request.setAttribute("view.jsp-showIconLabel", true);

String title = (String)request.getAttribute("view.jsp-title");

if (Validator.isNull(title)) {
	title = assetRenderer.getTitle(locale);
}

String viewURL = AssetPublisherHelperImpl.getAssetViewURL(liferayPortletRequest, liferayPortletResponse, assetEntry, viewInContext);

String viewURLMessage = viewInContext ? assetRenderer.getViewInContextMessage() : "read-more-x-about-x";

String summary = StringUtil.shorten(assetRenderer.getSummary(locale), abstractLength);
%>

<c:if test="<%= show %>">
	<div class="asset-abstract <%= defaultAssetPublisher ? "default-asset-publisher" : StringPool.BLANK %>">
		<liferay-util:include page="/html/portlet/asset_publisher/asset_actions.jsp" />

		<h3 class="asset-title">
		</h3>

		<div class="asset-content">
			<div class="asset-summary">

				<%
				String path = assetRenderer.render(renderRequest, renderResponse, AssetRenderer.TEMPLATE_ABSTRACT);

				request.setAttribute(WebKeys.ASSET_RENDERER, assetRenderer);
				request.setAttribute(WebKeys.ASSET_PUBLISHER_ABSTRACT_LENGTH, abstractLength);
				request.setAttribute(WebKeys.ASSET_PUBLISHER_VIEW_URL, viewURL);
				%>

				<c:choose>
					<c:when test="<%= path == null %>">
						<%= HtmlUtil.escape(summary) %>
					</c:when>
					<c:otherwise>
						<liferay-util:include page="<%= path %>" portletId="<%= assetRendererFactory.getPortletId() %>" />
					</c:otherwise>
				</c:choose>

				<h3 align="justify" style="margin-bottom: 0; line-height: 28px;" >
					<c:choose>
						<c:when test="<%= Validator.isNotNull(viewURL) %>">
							<a style="color: red; text-decoration: underline;" href="<%= viewURL %>"> <%= HtmlUtil.escape(title) %></a>
						</c:when>
						<c:otherwise>
							<img alt="" src="<%= assetRenderer.getIconPath(renderRequest) %>" /> <%= HtmlUtil.escape(title) %>
						</c:otherwise>
					</c:choose>
				</h3>

				<div class="asset-metadata-new">
					<%
						String value = null;
						for (int j = 0; j < metadataFields.length; j++) {
							if (metadataFields[j].equals("create-date")) {
								value = dateFormatDate.format(assetEntry.getCreateDate());
							}
						}
					%>
					<%= value %>
				</div>

				<%
					JournalArticle article = (JournalArticle)request.getAttribute(WebKeys.JOURNAL_ARTICLE);
					JournalArticleResource articleResource = JournalArticleResourceLocalServiceUtil.getArticleResource(article.getResourcePrimKey());
					String languageId = LanguageUtil.getLanguageId(request);
	
					JournalArticleDisplay articleDisplay = null;
					boolean workflowAssetPreview = GetterUtil.getBoolean((Boolean)request.getAttribute(WebKeys.WORKFLOW_ASSET_PREVIEW));
	
					if (!workflowAssetPreview && article.isApproved()) {
						String xmlRequest = PortletRequestUtil.toXML(renderRequest, renderResponse);
	
						articleDisplay = JournalContentUtil.getDisplay(articleResource.getGroupId(), articleResource.getArticleId(), null, null, languageId, themeDisplay, 1, xmlRequest);
					}
					else {
						articleDisplay = JournalArticleLocalServiceUtil.getArticleDisplay(article, null, null, languageId, 1, null, themeDisplay);
					}
					summary = HtmlUtil.escape(articleDisplay.getDescription());
					
					summary = HtmlUtil.replaceNewLine(summary);
				
					if (Validator.isNull(summary)) {
						summary = HtmlUtil.stripHtml(articleDisplay.getContent());
					}
				%>

				<div align="justify" class="txt-style" >
					<%= StringUtil.shorten(summary, abstractLength) %>
				</div>

			</div>

			<c:if test="<%= Validator.isNotNull(viewURL) %>">
				<div class="asset-more">
					<a style="text-decoration: underline;" href="<%= viewURL %>">Подробнее</a>
				</div>
			</c:if>
		</div>

	</div>
</c:if>
