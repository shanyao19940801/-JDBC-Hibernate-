<%--<%@ page import="com.sinitek.sirm.workflow.entity.IWorkflowApproveInfo" %>--%>
<%--<%@ page import="com.sinitek.sirm.workflow.service.WorkflowServiceFactory" %>--%>
<%@ page import="com.sinitek.sirm.busin.investpool.entity.IInvestPoolBatchCode" %>
<%@ page import="java.util.List" %>
<%--
 * File Desc:      
 * Product Name: SIRM
 * Module Name: InvestPool
 * Author:      陈松
 * History:     11-9-8 created by 陈松
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ taglib uri="http://www.sinitek.com/sirm/org/tag" prefix="org" %>--%>
<%@ include file="/includes/investpoolincludes.jsp" %>

<html>
<head><title>投资池工作流</title></head>
<sirm:body>
<%
//    List<IWorkflowApproveInfo> _approveList = null;
//    try {
//        _approveList = WorkflowServiceFactory.getWorkflowService().findApproveInfosBySourceEntitySourceId(IInvestPoolBatchCode.ENTITY_NAME, Integer.parseInt(request.getParameter("id")));
//    } catch (Exception e) {
//        e.printStackTrace();
//    }
//    request.setAttribute("approveList", _approveList);
%>
<script type="text/javascript">
    $(document).ready(function(){
        $(document).stk_removeSelf();
    });
function gotobaogao(id,type) {
        if(id!=null && id!='' && type == 1){
            $(document).stk_go("/rschreport/innerreport/viewinnerreport.action?reportId="+id+"", "查看报告");
        }else{
             $(document).stk_go("/rschreport/outerreport/viewouterreport.action?reportId=" + id + "", "查看外部报告");
        }
    }
    var err = "${error}";
    if(err != null && err != ''){
        stk.info(err);
    }
</script>
<div class="pool-info-box">
    <div class="hd stk-ui-bar">
        <span class="tit"><span>详细信息</span></span>
    </div>
    <div class="bd">
            <div class="pl10 pt10 pr10 pb10 zoom">
                <table class="stk-table stk-table-st1" width="100%">
                <thead>
                <tr>
                    <th class="stk-table-th " style="white-space:nowrap;">股票名称</th>
                    <th class="stk-table-th " style="white-space:nowrap;">投资池名称</th>
                    <th class="stk-table-th " style="white-space:nowrap;">调整类型</th>
                    <th class="stk-table-th " style="white-space:nowrap;">结果</th>
                    <th class="stk-table-th " style="white-space:nowrap;">评级</th>
                    <th class="stk-table-th " style="white-space:nowrap;">报告名称</th>
                    <th class="stk-table-th " style="white-space:nowrap;">附件名称</th>
                    <th class="stk-table-th " style="white-space:nowrap;">审批状态</th>
                </tr>

                </thead>
                <tbody>
                <c:forEach items="${allAdjustCheckResults}" var="i" varStatus="s">
                        <tr class="stk-table-tr-odd">
                            <td class="stk-table-td " style="text-align:center;">${i.sname}(${i.scode})</td>
                            <td class="stk-table-td " style="text-align:center;">${i.poolName}</td>
                            <td class="stk-table-td " style="text-align:center;">${i.adjustTypeName}</td>
                            <c:if test="${i.code==1 }">
                                <td class="stk-table-td alignL" style="text-align:center;">${i.description}</td>
                            </c:if>
                            <c:if test="${ i.code ==2}">
                                <td class="stk-table-td alignL" style="text-align:center;">成功</td>
                            </c:if>
                            <c:if test="${i.code==0}">
                                <td class="stk-table-td " style="text-align:center;"><font color="#dc143c">${i.description}</font></td>
                            </c:if>
                            <td class="stk-table-td alignL" style="text-align:center;">${i.pingji}</td>
                            <td class="stk-table-td " style="text-align:center;">
                                <c:forEach items="${i.ireports}" var="r" varStatus="s">
                                    <a href="#" onclick="gotobaogao(${r.id}+'',${r.type})"> ${r.title} </a>
                                    <c:if test="${!s.last}">
                                            ,
                                        </c:if>
                                </c:forEach>
                            </td>
                            <td class="stk-table-td " style="text-align:center;">
                                <c:forEach items="${i.attachments}" var="t" varStatus="s">
                                    <a href="${contextPath}/investpool/downloadattachment.action?objid=${t.id}" target="_blank"> ${t.name}</a>
                                    <c:if test="${!s.last}">
                                        <br/>
                                    </c:if>

                                </c:forEach>
                            </td>
                            <td class="stk-table-td " style="text-align:center;">
                                <c:if test="${i.iInvestPoolAdjustLog.ApproveStatus ==-1}">
                                    无效调整
                                </c:if>
                                <c:if test="${i.iInvestPoolAdjustLog.ApproveStatus == 10}">
                                    待审批
                                </c:if>
                                <c:if test="${i.iInvestPoolAdjustLog.ApproveStatus == 50}">
                                    审批驳回
                                </c:if>
                                <c:if test="${i.iInvestPoolAdjustLog.ApproveStatus == 100}">
                                    审批通过
                                </c:if>
                                <c:if test="${i.iInvestPoolAdjustLog.ApproveStatus == 150}">
                                                审批终止
                                            </c:if>
                            </td>
                        </tr>

                </c:forEach>
                </tbody>
            </table>

            </div>
    </div>
</div>
    <c:if test="${exampleid != null}">
        <jsp:include page="${path}/workflow/include/showworkflowhistory.jsp" flush="true">
            <jsp:param name="exampleid" value="${exampleid}"></jsp:param>
        </jsp:include>
    </c:if>
</sirm:body>
</html>