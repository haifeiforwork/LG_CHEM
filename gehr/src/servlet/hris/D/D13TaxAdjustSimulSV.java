package servlet.hris.D;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.db.*;
import hris.common.rfc.*;
import hris.D.*;
import hris.D.rfc.*;
import hris.D.D11TaxAdjust.*;
import hris.D.D11TaxAdjust.rfc.*;

/**
 * D13TaxAdjustSimulSV.java
 * 연말정산공제 Simulation 할 수 있도록 하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/01/30
 */
public class D13TaxAdjustSimulSV extends EHRBaseServlet {

    //private String UPMU_TYPE ="";            // 결재 업무타입(연말정산공제)
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;
        try{
            HttpSession  session          = req.getSession(false);
            WebUserData  user             = (WebUserData)session.getAttribute("user");
            Box          box              = WebUtil.getBox(req);

            String dest       = "";
            String jobid      = "";
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }

            String targetYear = box.get("targetYear");   //[?????]  targetYear => 요거 변수명 바뀔수도 있음
            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            String beginDate  = targetYear+"0101";
            String endDate    = targetYear+"1231";

            D13TaxAdjustSimulRFC   simulRfc          = new D13TaxAdjustSimulRFC();
            D13TaxAdjustSimulation simul             = new D13TaxAdjustSimulation();
            D13TaxAdjustSimulData  simulData         = null;
            D14TaxAdjustData       d14TaxAdjustData  = null;
            D13TaxAdjustData       d13TaxAdjustData  = new D13TaxAdjustData();

            // Simulation
            box.copyToEntity(d13TaxAdjustData);
            Logger.debug.println(this,box.toString());
            Logger.debug.println(this,d13TaxAdjustData.toString());
/*
            d13TaxAdjustData._총급여                   = 2800*MANWON;
            d13TaxAdjustData._과세대상근로소득         = 2800*MANWON;
            d13TaxAdjustData._근로소득금액             = 0*MANWON;
            d13TaxAdjustData._당해과세연도종합소득금액 = 0*MANWON;
            d13TaxAdjustData._국외원천근로소득금액     = 0*MANWON;
            d13TaxAdjustData._기납부세액               = 50*MANWON;

            d13TaxAdjustData._인적공제총액             = 650*MANWON;
            d13TaxAdjustData._의료보험료               = 30*MANWON;
            d13TaxAdjustData._고용보험료               = 70*MANWON;
            d13TaxAdjustData._보험료일반               = 10*MANWON;
            d13TaxAdjustData._보험료장애자             = 10*MANWON;
            d13TaxAdjustData._의료비일반               = 123*MANWON;
            d13TaxAdjustData._의료비경로장애           = 123*MANWON;
            d13TaxAdjustData._주택자금저축금액         = 30*MANWON;
            d13TaxAdjustData._주택자금차입원리금       = 10*MANWON;
            d13TaxAdjustData._주택자금차입이자상환     = 10*MANWON;
            d13TaxAdjustData._기부금법정               = 100*MANWON;
            d13TaxAdjustData._기부금지정               = 0*MANWON;
            d13TaxAdjustData._교육비본인               = 12*MANWON;
            d13TaxAdjustData._교육비영유아             = 80*MANWON;
            d13TaxAdjustData._교육비초중고             = 100*MANWON;
            d13TaxAdjustData._교육비대학               = 0*MANWON;
            d13TaxAdjustData._개인연금I                = 10*MANWON;
            d13TaxAdjustData._개인연금II               = 10*MANWON;
            d13TaxAdjustData._국민연금                 = 10*MANWON;
            d13TaxAdjustData._투자조합공제I            = 10*MANWON;
            d13TaxAdjustData._투자조합공제II           = 10*MANWON;
            d13TaxAdjustData._신용카드공제        ;    = 1000*MANWON
            d13TaxAdjustData._주택자금이자상환         = 10*MANWON;
            d13TaxAdjustData._근로자주식저축           = 10*MANWON;
            d13TaxAdjustData._장기증권저축             = 10*MANWON;
            d13TaxAdjustData._외국납부세당년           = 0*MANWON;
            d13TaxAdjustData._외국납부세이월분         = 0*MANWON;
*/
            // 총소득, 총비과세소득등의 데이터를 가져오자
            simulData = (D13TaxAdjustSimulData)simulRfc.detail( user.empNo, beginDate, endDate );
            Logger.debug.println(this,simulData.toString());

            d13TaxAdjustData._총급여           = (simulData.O_TOTINCOM.equals("") ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_TOTINCOM)));
            d13TaxAdjustData._과세대상근로소득 = (simulData.O_TAXGROSS.equals("") ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_TAXGROSS)));
            //d13TaxAdjustData._총급여           = 3000 * 10000;// 총지급임금
            //d13TaxAdjustData._과세대상근로소득 = 3000 * 10000;// 총과세소득

            // 시뮬레이션 실행
            d14TaxAdjustData = (D14TaxAdjustData)simul.simulate(d13TaxAdjustData);
            Logger.debug.println(this,"시뮬레이션 실행 직후 : "+d14TaxAdjustData.toString());

            // 기본공제와 추가공제, 소수공제자추가 데이타를 request 로 받아온다
            d14TaxAdjustData._기본공제_본인       = box.getDouble("_기본공제_본인"      );
            d14TaxAdjustData._기본공제_배우자     = box.getDouble("_기본공제_배우자"    );
            d14TaxAdjustData._기본공제_부양가족   = box.getDouble("_기본공제_부양가족"  );
            d14TaxAdjustData._추가공제_경로우대   = box.getDouble("_추가공제_경로우대"  );
            d14TaxAdjustData._추가공제_장애인     = box.getDouble("_추가공제_장애인"    );
            d14TaxAdjustData._추가공제_부녀자     = box.getDouble("_추가공제_부녀자"    );
            d14TaxAdjustData._추가공제_자녀양육비 = box.getDouble("_추가공제_자녀양육비");
//            d14TaxAdjustData._소수공제자추가공제  = box.getDouble("_소수공제자추가공제" );

            d14TaxAdjustData._급여총액            =(simulData.O_GROSS.equals("")    ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_GROSS    )));// 총액
            d14TaxAdjustData._총급여              =(simulData.O_TOTINCOM.equals("") ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_TOTINCOM )));// 총지급임금
            //d14TaxAdjustData._과세대상근로소득금액=(simulData.O_TAXGROSS.equals("") ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_TAXGROSS )));// 총과세소득
            d14TaxAdjustData._비과세소득_국외근로 =(simulData.O_NTAXGROSS.equals("")?0:Double.parseDouble(DataUtil.removeComma(simulData.O_NTAXGROSS)));// 총비과세소득
            d14TaxAdjustData._기납부세액_갑근세   =(simulData.O_INCOMTAX.equals("") ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_INCOMTAX )));// 총근로소득세
            d14TaxAdjustData._기납부세액_주민세   =(simulData.O_RESTAX.equals("")   ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_RESTAX   )));// 총주민세
            d14TaxAdjustData._기납부세액_농특세   =(simulData.O_SPTAX.equals("")    ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_SPTAX    )));// 총특별세
/*
            d14TaxAdjustData._급여총액            = 3000 * 10000;// 총액
            d14TaxAdjustData._총급여              = 3000 * 10000;// 총지급임금
            d14TaxAdjustData._과세대상근로소득금액= 3000 * 10000;// 총과세소득
            d14TaxAdjustData._비과세소득_국외근로 = 0 * 10000;// 총비과세소득
            d14TaxAdjustData._기납부세액_갑근세   = 500 * 10000;// 총근로소득세
            d14TaxAdjustData._기납부세액_주민세   = 1 * 10000;// 총주민세
            d14TaxAdjustData._기납부세액_농특세   = 2 * 10000;// 총특별세
*/

            d14TaxAdjustData._상여총액 = d14TaxAdjustData._총급여 - d14TaxAdjustData._급여총액 ;

            // 차감소득금액 계산
            double hap2  = d14TaxAdjustData._기본공제_본인       ;
                   hap2 += d14TaxAdjustData._기본공제_배우자     ;
                   hap2 += d14TaxAdjustData._기본공제_부양가족   ;
                   hap2 += d14TaxAdjustData._추가공제_경로우대   ;
                   hap2 += d14TaxAdjustData._추가공제_장애인     ;
                   hap2 += d14TaxAdjustData._추가공제_부녀자     ;
                   hap2 += d14TaxAdjustData._추가공제_자녀양육비 ;
//                   hap2 += d14TaxAdjustData._소수공제자추가공제  ;
//                   hap2 += d14TaxAdjustData._특별공제계          ;
                   hap2 += d14TaxAdjustData._연금보험료공제      ;

//            d14TaxAdjustData._차감소득금액 = d14TaxAdjustData._과세대상근로소득금액 - hap2 ;

            // 결정세액합계 계산       
            double hap4  = d14TaxAdjustData._결정세액_갑근세 ;
                   hap4 += d14TaxAdjustData._결정세액_주민세 ;
                   hap4 += d14TaxAdjustData._결정세액_농특세 ;
            d14TaxAdjustData._결정세액합계 = hap4 ;

            // 기납부세액합계 계산     
            double hap5  = d14TaxAdjustData._기납부세액_갑근세 ;
                   hap5 += d14TaxAdjustData._기납부세액_주민세 ;
                   hap5 += d14TaxAdjustData._기납부세액_농특세 ;
            d14TaxAdjustData._기납부세액합계 = hap5 ;

            d14TaxAdjustData._차감징수세액_갑근세 = d14TaxAdjustData._결정세액_갑근세 - d14TaxAdjustData._기납부세액_갑근세;
            d14TaxAdjustData._차감징수세액_주민세 = d14TaxAdjustData._결정세액_주민세 - d14TaxAdjustData._기납부세액_주민세;
            d14TaxAdjustData._차감징수세액_농특세 = d14TaxAdjustData._결정세액_농특세 - d14TaxAdjustData._기납부세액_농특세;

            // 차감징수세액합계 계산   
            double hap6  = d14TaxAdjustData._차감징수세액_갑근세 ;
                   hap6 += d14TaxAdjustData._차감징수세액_주민세 ;
                   hap6 += d14TaxAdjustData._차감징수세액_농특세 ;
            d14TaxAdjustData._차감징수세액합계 = hap6 ;


            Logger.debug.println(this,d14TaxAdjustData.toString());
            req.setAttribute( "targetYear"      , targetYear);
            req.setAttribute( "d14TaxAdjustData", d14TaxAdjustData);

            dest = WebUtil.JspURL+"D/D13TaxAdjustSimul.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}
