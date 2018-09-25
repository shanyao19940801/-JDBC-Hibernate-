<%@ page import="java.util.List" %>
<%@ page import="com.sinitek.sirm.busin.investpool.entity.IInvestPoolAdjustLog" %>
<%@ page import="com.sinitek.sirm.common.sirmenum.utils.EnumUtils" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.apache.commons.collections.MapUtils" %>
<%@ page import="com.sinitek.sirm.busin.basedata.service.ISecurityService" %>
<%@ page import="com.sinitek.sirm.common.spring.SpringFactory" %>
<%@ page import="com.sinitek.sirm.busin.basedata.entity.Security" %>
<%@ page import="com.sinitek.sirm.web.investpool.utils.InvestPoolUtils" %>
<%@ page import="com.sinitek.sirm.busin.stockresearch.entity.IStockForecastDetail" %>
<%@ page import="com.sinitek.sirm.busin.stockresearch.service.StockResearchServiceFactory" %>
<%@ page import="com.sinitek.sirm.busin.stockresearch.entity.IStockForecast" %>
<%@ page import="com.sinitek.sirm.common.utils.NumberTool" %>
<%@ page import="com.sinitek.sirm.common.utils.TimeUtil" %>
<%--<%@ page import="com.sinitek.sirm.workflow.entity.IWorkflowApproveInfo" %>--%>
<%--<%@ page import="com.sinitek.sirm.workflow.service.WorkflowServiceFactory" %>--%>
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
<head><title>投资池工作流</title>
    <script type="text/javascript" src="${contextPath}/common/attachment/downattachmentwindow.js" charset="UTF-8"></script>
</head>
<sirm:body>
<%
   //查询股票上次投资评级
    Map m = (Map)request.getAttribute("m");
    String scode = MapUtils.getString(m, "hscode", "");
    int mktcode = MapUtils.getIntValue(m, "hmktcode", 0);
    int stype = MapUtils.getIntValue(m, "hstype", 0);
    IStockForecast stockForecast = StockResearchServiceFactory.getStockForecastService().getLastStockForecast(scode, stype, mktcode, 2,new int[]{100});
    String previousForcast = "";
    if(stockForecast!=null) {
        List<IStockForecastDetail> forecastDetails = StockResearchServiceFactory.getStockForecastDetailService().findStockForecastDetailByForecastid(stockForecast.getId(), "0002");
        for(IStockForecastDetail forecastDetail : forecastDetails){
            if(forecastDetail.getIndicatorCode().equals("0009"))
            {
                String forcastValue= EnumUtils.getSirmEnumName("StockResearch", "investrank", NumberTool.safeToInteger(forecastDetail.getForcastValue(), 0)).getName();
                String forcastTime = TimeUtil.formatDate(forecastDetail.getForcastTime(), "yyyy-MM-dd HH:mm:ss");
                previousForcast = forcastValue +" (评级时间："+ forcastTime+")";
            }
        }
    }

    request.setAttribute("previousForcast", previousForcast);

%>
<script type="text/javascript">
function gotobaogao(id,type) {
        if(id!=null && id!='' && type == 1){
            $(document).stk_go("/rschreport/innerreport/viewinnerreport.action?reportId="+id+"", "查看报告");
        }else{
             $(document).stk_go("/rschreport/outerreport/viewouterreport.action?reportId=" + id + "", "查看外部报告");
        }
    }

</script>
<form action="investpooladjustmanageaction!inquestInvestPool.action" id="inquestInvestPoolForm" method="post">
<input type="hidden" name="id" value="${param.id}">
<input type="hidden" name="isend" value="${param.isend}">
<input type="hidden" name="stepid" value="${param.stepid}">
<input type="hidden" value="${m.hmktcode}" name="mktcode" id="hmktcode">
<input type="hidden" value="${m.hstype}" name="stype" id="hstype">
<input type="hidden" value="${m.hscode}" name="scode" id="hscode">
<input type="hidden" name="poolIdsAndpoolSeq" value="${m.poolIdsAndpoolSeq}">
<input type="hidden" name="succeedOutPoolId" value="${succeedOutPoolId}">
<input type="hidden" name="succeedInPoolId" value="${succeedInPoolId}">
<input type="hidden" name="exampleownerid" value="${exampleownerid}">
<input type="hidden" name="examplestepid" value="${examplestepid}">
<input type="hidden" name="exampleid" value="${exampleid}">
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
                    <th class="stk-table-th alignL" style="white-space:nowrap;">投资池名称</th>
                    <th class="stk-table-th alignL" style="white-space:nowrap;">调整类型</th>
                    <th class="stk-table-th alignL" style="white-space:nowrap;">结果</th>
                    <th class="stk-table-th alignL" style="white-space:nowrap;">报告名称</th>
                    <th class="stk-table-th alignL" style="white-space:nowrap;">附件名称</th>
                    <th class="stk-table-th alignL" style="white-space:nowrap;">审批状态</th>
                </tr>

                </thead>
                <tbody>
                <c:forEach items="${allAdjustCheckResults}" var="i" varStatus="s">
                        <tr class="stk-table-tr-odd">
                            <td class="stk-table-td alignL" style="text-align:center;">${i.poolName}</td>
                            <td class="stk-table-td alignL" style="text-align:center;">${i.adjustTypeName}</td>
                            <c:if test="${i.code==1}">
                                <td class="stk-table-td alignL" style="text-align:center;">${i.description}</td>
                            </c:if>
                            <c:if test="${i.code==0}">
                                <td class="stk-table-td alignL" style="text-align:center;"><font color="#dc143c">${i.description}</font></td>
                            </c:if>
                            <c:if test="${i.code==2}">
                                    <td class="stk-table-td alignL" style="text-align:center;">正常调整 该投资产品在弹性禁投池（${i.description}）</td>
                                </c:if>
                            <td class="stk-table-td alignL" style="text-align:center;">
                                <c:forEach items="${i.ireports}" var="r" varStatus="s">
                                    <a href="#" onclick="gotobaogao(${r.id}+'',${r.type})" > ${r.title} </a>
                                    <c:if test="${!s.last}">
                                           <br/>
                                        </c:if>
                                </c:forEach>
                            </td>
                            <td class="stk-table-td alignL" style="text-align:center;">
                                <c:forEach items="${i.attachments}" var="t" varStatus="s">
                                    <a href="${contextPath}/investpool/downloadattachment.action?objid=${t.id}" target="_blank"> ${t.name}</a>
                                    <c:if test="${!s.last}">
                                        <br/>
                                    </c:if>

                                </c:forEach>
                            </td>
                            <td class="stk-table-td alignL" style="text-align:center;">
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
    <div class="stk-box-s2">
        <div class="stk-hd stk-ui-bar"><span class="stk-tit"><label><input type="checkbox" class="verMiddle">上次投资评级</label></span></div>
        <div class="stk-bd zoom">
            <c:if test="${previousForcast !=''}">
            <table width="100%">
                <tr>
                    <td class="hd" width="10%" align="center" height="25px"><label>投资评级&nbsp;</label></td>
                    <td class="hd" align="left">
                        <label>&nbsp;${previousForcast}</label>
                    </td>
            </table>
            </c:if>
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
            <td class="td" align="left">
                <label>&nbsp;${m.Reason}</label>
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

    <div class="stk-box-s2">
        <div class="stk-hd stk-ui-bar"><span class="stk-tit"><label><input type="checkbox" class="verMiddle">审批</label></span></div>
        <div class="stk-bd zoom">
            <table width="100%"  class="stk-form-ui-st1">
                <c:if test="${param.isvote == null || param.isvote == 0}">
                    <tr align="left">
                        <td class="hd">
                            是否审批通过
                        </td>
                        <td class="bd" colspan="5">
                            <ui:radiobox name="approve" id="yes" value="1" checked="true">
                            </ui:radiobox>是 &nbsp;&nbsp;
                            <ui:radiobox name="approve" id="no" value="2">
                            </ui:radiobox>否（驳回）
                        </td>
                    </tr>
                    <tr>
                        <td class="hd">
                            审批意见
                        </td>
                        <td class="bd" colspan="5">
                            <ui:textarea rows="8" width="500px" id="opinion" name="opinion"></ui:textarea>
                        </td>
                    </tr>
                </c:if>
                <c:if test="${param.isvote == 1}">
                    <tr align="left">
                        <td class="hd">
                            选择投票结果
                        </td>
                        <td class="bd" colspan="5">
                            <ui:radiobox name="approve" id="yes" value="1">
                            </ui:radiobox>同意 &nbsp;&nbsp;
                            <ui:radiobox name="approve" id="no" value="2">
                            </ui:radiobox>反对 &nbsp;&nbsp;
                            <%--<ui:radiobox name="approve" id="waiver" value="2" checked="true">--%>
                            <%--</ui:radiobox>弃权--%>
                        </td>
                    </tr>
                    <tr>
                        <td class="hd">
                            投票意见
                        </td>
                        <td class="bd" colspan="5">
                            <ui:textarea rows="8" width="500px" id="opinion" name="opinion"></ui:textarea>
                        </td>
                    </tr>
                </c:if>



           </table>
           </div>
        </div>

<div class="submit-btn-bar">
    <c:if test="${isok == 'ok'}">
    <ui:button text="提交审批" id="approveButton">
        <event:onclick>
            <%--var approve = $("#yes").attr("checked");--%>
            <%--if(approve == 0){--%>
            var approve = $("#no").attr("checked");
            if(approve == 1){
                stk.confirm("确认驳回么？", function() {
                    if (${maillink eq "true"} || ${maillink eq true}) {
                    $('#approveButton').attr('disabled','disabled');
                    ajaxSubmit();
                    } else {
                    $("#inquestInvestPoolForm").submit();
                    $('#approveButton').attr('disabled','disabled');
                    <%--jumpIntegration();--%>
                    }
                });
            }else{
                if (${maillink eq "true"} || ${maillink eq true}) {
                $('#approveButton').attr('disabled','disabled');
                ajaxSubmit();
                } else {
                $("#inquestInvestPoolForm").submit();
                $('#approveButton').attr('disabled','disabled');
                <%--jumpIntegration();--%>
                }
            }
            <%--}else if(approve == 1){--%>
                <%--$("#checkInquestInvestPoolForm").stk_submit(function(result){--%>
                    <%--if(result== ''){--%>
                        <%--$("#inquestInvestPoolForm").submit();--%>
                        <%--$('#approveButton').attr('disabled','disabled');--%>
                    <%--}else{--%>
                        <%--stk.info(result);--%>
                    <%--}--%>
                <%--});--%>
            <%--}--%>
        </event:onclick>
    </ui:button>
    </c:if>
    <c:if test="${isok == 'err'}">
        <ui:button text="提交审批" id="approveButton">
            <event:onclick>
                stk.info("你没有权限审批");
            </event:onclick>
        </ui:button>
    </c:if>
</div>
</form>
<c:if test="${exampleid != null}">
    <jsp:include page="${path}/workflow/include/showworkflowhistory.jsp" flush="true">
        <jsp:param name="exampleid" value="${exampleid}"></jsp:param>
    </jsp:include>
</c:if>
<ui:form id="checkInquestInvestPoolForm" clazz="com.sinitek.sirm.web.investpool.InvestPoolAdjustManageAction" method="checkInquestInvestPool">
    <input name="checkLogId" value="${param.id}" type="hidden" id="checkLogId">
</ui:form>


<script type="text/javascript">
    $(document).ready(function() {
        sirm.form.checker.checkInputContent('#opinion', 250);
    });

    function jumpIntegration() {
        if (${maillink eq "true"} || ${maillink eq true}) {
            if (${havetodo eq "true"} || ${havetodo eq true}) {
                if (${not empty ythUrl}) {
                    var explorer = window.navigator.userAgent.toLowerCase();
                    if (explorer.indexOf("msie") >= 0) {
                        window.opener = null;
                        window.open("", "_self");
                    }
                    window.open("${ythUrl}", "_blank");
                }
            }
            window.close();
        }
    }

    function ajaxSubmit() {
        var approve = $("#no").attr("checked");
        var opinion = $("#opinion").stk_val();
        var newWindow = window.open();  //新开一个，避免ajax里面弹窗拦截
        $.ajax({
            url: "${contextPath}/investpool/investpooladjustmanageaction!inquestInvestPool.action",
            type: "post",
            dataType: "json",
            data: {
                "id": "${param.id}",
                "isend": "${param.isend}",
                "stepid": "${param.stepid}",
                "mktcode": "${m.hmktcode}",
                "stype": "${m.hstype}",
                "scode": "${m.hscode}",
                "poolIdsAndpoolSeq": "${m.poolIdsAndpoolSeq}",
                "succeedOutPoolId": "${succeedOutPoolId}",
                "succeedInPoolId": "${succeedInPoolId}",
                "exampleownerid": "${exampleownerid}",
                "examplestepid": "${examplestepid}",
                "exampleid": "${exampleid}",
                "approve": approve,
                "opinion": opinion
            },
            success: function (data) {
                if (${havetodo eq "true"} || ${havetodo eq true}) {
                    if (${not empty ythUrl}) {
                        var explorer = window.navigator.userAgent.toLowerCase();
                        if (explorer.indexOf("msie") >= 0) {
                            window.opener = null;
                            window.open("", "_self");
                        }
                        newWindow.location.href = "${ythUrl}";
                    }
                } else {
                    newWindow.close();
                }
                window.close();
            },
            error: function (e) {
                if (${havetodo eq "true"} || ${havetodo eq true}) {
                    if (${not empty ythUrl}) {
                        var explorer = window.navigator.userAgent.toLowerCase();
                        if (explorer.indexOf("msie") >= 0) {
                            window.opener = null;
                            window.open("", "_self");
                        }
                        newWindow.location.href = "${ythUrl}";
                    }
                } else {
                    newWindow.close();
                }
                window.close();
            }
        });
    }
</script>
</sirm:body>
</html>