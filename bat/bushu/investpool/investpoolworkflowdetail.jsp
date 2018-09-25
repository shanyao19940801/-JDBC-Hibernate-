<%@ page import="java.util.Map" %>
<%@ page import="com.sinitek.sirm.common.sirmenum.utils.EnumUtils" %>
<%--
 * File Desc:      
 * Product Name: SIRM
 * Module Name: InvestPool
 * Author:      陈松
 * History:     11-5-18 created by 陈松
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/includes/investpoolincludes.jsp" %>

<html>
<head><title>投资池工作流</title></head>
<sirm:body>
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
    <jsp:include page="/includes/includesecurity.jsp"/>
<div class="pool-info-box">
    <div class="hd stk-ui-bar">
        <span class="tit"><span>详细信息</span></span>
    </div>
    <div class="bd">
            <div class="pl10 pt10 pr10 pb10 zoom">
                <table class="stk-table stk-table-st1" width="100%">
                <thead>
                <tr>
                    <th class="stk-table-th " style="white-space:nowrap;">投资池名称</th>
                    <th class="stk-table-th " style="white-space:nowrap;">调整类型</th>
                    <th class="stk-table-th " style="white-space:nowrap;">结果</th>
                    <th class="stk-table-th " style="white-space:nowrap;">报告名称</th>
                    <th class="stk-table-th " style="white-space:nowrap;">附件名称</th>
                    <th class="stk-table-th " style="white-space:nowrap;">审批状态</th>
                </tr>

                </thead>
                <tbody>
                <c:forEach items="${allAdjustCheckResults}" var="i" varStatus="s">
                        <tr class="stk-table-tr-odd">
                            <td class="stk-table-td " style="text-align:center;">${i.poolName}</td>
                            <td class="stk-table-td " style="text-align:center;">${i.adjustTypeName}</td>

                            <c:if test="${i.code==1 || i.code==2 || i.iInvestPoolAdjustLog.ApproveStatus == 100 }">
                                <td class="stk-table-td alignL" style="text-align:center;"> 成功</td>
                            </c:if>
                            <c:if test="${i.code==0 && i.iInvestPoolAdjustLog.ApproveStatus != 100}">
                                <td class="stk-table-td " style="text-align:center;"><font color="#dc143c">${i.description}</font></td>
                            </c:if>

                            <td class="stk-table-td " style="text-align:center;">
                                <c:forEach items="${i.ireports}" var="r" varStatus="s">
                                    <a href="#" onclick="gotobaogao(${r.id}+'',${r.type})"  > ${r.title} </a>
                                    <c:if test="${!s.last}">
                                           <br/>
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
    <div class="stk-box-s2">
        <div class="stk-hd stk-ui-bar"><span class="stk-tit"><label><input type="checkbox" class="verMiddle">调整盈利预测</label></span></div>
        <div class="stk-bd zoom">
            <sirmsr:profitforecastview

                    sourceEntity="INVESTPOOLADJUSTLOG" sourceId="${m.SourceId}">
            </sirmsr:profitforecastview>
           </div>
        </div>
    <div class="stk-box-s2">
        <div class="stk-hd stk-ui-bar"><span class="stk-tit"><label><input type="checkbox" class="verMiddle">调整投资评级</label></span></div>
        <div class="stk-bd zoom">
            <sirmsr:investforecastview
                    group="0002"
                    sourceEntity="INVESTPOOLADJUSTLOG" sourceId="${m.SourceId}">
            </sirmsr:investforecastview>
           </div>
        </div>
    <%
           Map<Integer, String> _mapLower =  EnumUtils.findSirmEnumByCataLogAndType("InvestPool", "LOWERPOOL");
           Map<Integer, String> _mapOut =  EnumUtils.findSirmEnumByCataLogAndType("InvestPool","OUTPOOL");
           pageContext.setAttribute("mapLower",_mapLower);
           pageContext.setAttribute("mapOut",_mapOut);
     %>
        <c:if test="${not empty lowerPool}">
           <layout:panel title="下调股票池" collapsible="true" >
               <c:forEach items="${mapLower}" var="_lower">
                   <input type="checkbox" value="${_lower.key}" disabled <c:if test="${fn:indexOf(lowerPool, _lower.key)>-1}"> checked </c:if>>${_lower.value}&nbsp;&nbsp;
               </c:forEach>
           </layout:panel>
        </c:if>
        <c:if test="${not empty outPool}">
           <layout:panel title="剔除股票池" collapsible="true">
                  <c:forEach items="${mapOut}" var="_out">
                      <input type="checkbox"  value="${_out.key}" disabled <c:if test="${fn:indexOf(outPool, _out.key)>-1}"> checked </c:if>>${_out.value}&nbsp;&nbsp;
                  </c:forEach>
              </layout:panel>
        </c:if>
    <div class="stk-box-s2">
        <div class="stk-hd stk-ui-bar"><span class="stk-tit"><label><input type="checkbox" class="verMiddle">原因建议</label></span></div>
        <div class="stk-bd zoom">
            <table width="100%">
               <tr>
            <td class="hd" width="10%" align="center"><label>原因&nbsp;</label></td>
            <td class="td" align="left">&nbsp;
                <label>${m.Reason}</label>
            </td>
         <tr>
            <td class="hd" width="10%" align="center"><label>建议&nbsp;</label></td>
            <td class="td" align="left">
                <label>&nbsp;${m.Suggest}</label>
            </td>
        </tr>
           </table>
           </div>
        </div>
    <c:if test="${exampleid != null}">
        <jsp:include page="${path}/workflow/include/showworkflowhistory.jsp" flush="true">
            <jsp:param name="exampleid" value="${exampleid}"></jsp:param>
        </jsp:include>
    </c:if>
</sirm:body>
</html>