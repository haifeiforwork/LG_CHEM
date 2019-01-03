package servlet.hris.D;

import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.*;
import hris.D.*;
import hris.D.rfc.*;
import hris.D.D09Bond.rfc.*;

/**
 * D15RetirementSimulSV.java
 * 퇴직금소득공제 Simulation 할 수 있도록 하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/02/06
 * @update 2014/11/27 [CSR ID:2651601] E-HR 퇴직금 시뮬레이션 메뉴 수정 
 */
public class D15RetirementSimulSV extends EHRBaseServlet {

    //private String UPMU_TYPE ="";            // 결재 업무타입(퇴직금소득공제)
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;
        try{
            HttpSession  session = req.getSession(false);
            WebUserData  user    = (WebUserData)session.getAttribute("user");
            Box          box     = WebUtil.getBox(req);

            double G_REST_AMNT   = 0.0 ;  // 채권가압류 잔액 계
            double G_O_BONDM     = 0.0 ;  // 채권가압류 공제
            
            D09BondListRFC func1 = new D09BondListRFC();
            
            String dest       = "";
            String jobid      = "";
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            D15RetirementSimulRFC   simulRfc  = new D15RetirementSimulRFC();
            D15RetirementSimulData  d15RetirementSimulData = null;

            // 퇴직급여,퇴직수당(?),근속년수 등을 가져온다.
            String retireDate = box.get("fu_retireDate");
            if(retireDate.equals("")){
                retireDate = DataUtil.getCurrentDate();
            }
            d15RetirementSimulData = (D15RetirementSimulData)simulRfc.getRetirementData( user.empNo, retireDate );
            d15RetirementSimulData.fu_retireDate = retireDate ;
            
//          ===========================================================================================
//          2002.06.20. 채권가압류 공제 = [ 퇴직금 총액
//                                      - (퇴직갑근세 + 퇴직주민세 + 퇴직전환금 + (????????퇴직농특세)) ] / 2
//          채권가압류 금액이 계산된 금액 잔액보다 작으면 : 채권가압류 잔액이 공제액.
//                                               크면   : 계산된 금액이 공제액.
//          ===========================================================================================
//          G_REST_AMNT - ZHRP_RFC_BOND_PRESENTSTATE - 채권가압류 잔액 계
            G_REST_AMNT = Double.parseDouble( func1.getG_REST_AMNT( user.empNo ) ) ;
            
//          2002.07.23. 해지된 채권가압류를 제외한 금액을 넘겨줘서 계산에 반영한다.
//                      RFC 펑션에서는 RT에서 채권가압류를 읽을때 해지된 금액을 체크하지 못한다.
            // 시뮬레이션 실행
            Logger.debug.println(this,"Before Simulation for Retirement : "+d15RetirementSimulData.toString());
            d15RetirementSimulData.O_BONDM = Double.toString( G_REST_AMNT );
            d15RetirementSimulData = (D15RetirementSimulData)simulRfc.simulate(d15RetirementSimulData);
            Logger.debug.println(this,"After Simulation for Retirement : "+d15RetirementSimulData.toString());
//-------------------------------------------------------------------------------------------------------------                
            
            if( G_REST_AMNT > 0 ) {
                G_O_BONDM = ( Double.parseDouble(d15RetirementSimulData.GRNT_RSGN)
                                                         - (Double.parseDouble(d15RetirementSimulData._퇴직갑근세) 
                                                         +  Double.parseDouble(d15RetirementSimulData._퇴직주민세)
                                                         +  Double.parseDouble(d15RetirementSimulData.O_NAPPR)) ) / 2; 
                if( G_REST_AMNT < G_O_BONDM ) {
                    G_O_BONDM = G_REST_AMNT;
                }
                
                d15RetirementSimulData.O_BONDM = Double.toString(G_O_BONDM);
            } else {
                d15RetirementSimulData.O_BONDM = "0";
            }

//          2002.09.03. 계산된 채권가압류 공제액을 가지고 공제총액을 새로 구하기위해서 simulate를 한번 더 호출한다.
//                      후에 추가된 로직으로 변경하기 복잡하여 임시로 다시 한번 호출함.
            Logger.debug.println(this,"Before Simulation for Retirement : "+d15RetirementSimulData.toString());
            d15RetirementSimulData = (D15RetirementSimulData)simulRfc.simulate(d15RetirementSimulData);
            Logger.debug.println(this,"After Simulation for Retirement : "+d15RetirementSimulData.toString());
//          2002.09.03. 계산된 채권가압류 공제액을 가지고 공제총액을 새로 구하기위해서 simulate를 한번 더 호출한다.
            
            req.setAttribute( "d15RetirementSimulData", d15RetirementSimulData);
            
            //20141127 [CSR ID:2651601] E-HR 퇴직금 시뮬레이션 메뉴 수정 
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(user.empNo);
            req.setAttribute("PersonData" , phonenumdata );

            dest = WebUtil.JspURL+"D/D15RetirementSimul.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}
