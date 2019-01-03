/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 사원평가                                                    */
/*   Program Name : 평가사항 조회                                               */
/*   Program ID   : B01ValuateDetailRFC                                         */
/*   Description  : 사원의 평가 사항을 가져오는 RFC를 호출하는 Class            */
/*   Note         : [관련 RFC] : ZHRD_RFC_APPRAISAL_LIST                        */
/*   Creation     : 2002-01-14  한성덕                                          */
/*   Update       : 2005-01-11  윤정현                                          */
/*                      2018/05/21 rdcamel [CSR ID:3687969] 인사기록부상 해외법인명 한글병기 요청의 건                                                       */
/********************************************************************************/

package hris.B.rfc ;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.B.B01ValuateDetailData;

import java.util.Vector;

public class B01ValuateDetailRFC extends SAPWrap {

    private  static String functionName = "ZGHR_RFC_APPRAISAL_LIST" ;

    /** 
     * 사원의 평가 사항을 가져오는 RFC를 호출하는 Method
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */ 
    public Vector<B01ValuateDetailData> getValuateDetail( String I_PERNR, String I_LEADER, String I_LPERNR, String I_CFORM, String I_REENTRY) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            /*
            I_PERNR		 NUMC 	 8 	사원번호
            I_MOLGA		CHAR	 2 	국가그룹핑
            I_DATUM		 DATS 	 8 	기준일자
            I_SPRSL		 DATS 	 8 	언어
            I_PYEAR		 NUMC 	 4 	조회 시작연도
            I_PTIMES		 INT 	 10 	평가 조회할 LOOP CNT
            I_LEADER		 CHAR 	 1 	팀장여부
            I_LPERNR		 NUMC 	 8 	 팀장사번
             */
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_LEADER", I_LEADER);
            setField(function, "I_LPERNR", I_LPERNR);
            setField(function, "I_CFORM", I_CFORM);
            setField(function, "I_REENTRY", I_REENTRY);

            if("X".equals(I_CFORM))
                setField(function, "I_PTIMES", "20");


            excute( mConnection, function ) ;

            return getTable(B01ValuateDetailData.class, function, "T_LIST");

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    
    
    
    /**
     * 사원의 평가 사항을 가져오는 RFC를 호출하는 Method(영문 약어 조직 text 추가제공)
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     *  @author rdcamel [CSR ID:3687969] 인사기록부상 해외법인명 한글병기 요청의 건
     */ 
    public Vector<B01ValuateDetailData> getValuateDetailLong( String I_PERNR, String I_LEADER, String I_LPERNR, String I_CFORM, String I_REENTRY) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            /*
            I_PERNR		 NUMC 	 8 	사원번호
            I_MOLGA		CHAR	 2 	국가그룹핑
            I_DATUM		 DATS 	 8 	기준일자
            I_SPRSL		 DATS 	 8 	언어
            I_PYEAR		 NUMC 	 4 	조회 시작연도
            I_PTIMES		 INT 	 10 	평가 조회할 LOOP CNT
            I_LEADER		 CHAR 	 1 	팀장여부
            I_LPERNR		 NUMC 	 8 	 팀장사번
             */
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_LEADER", I_LEADER);
            setField(function, "I_LPERNR", I_LPERNR);
            setField(function, "I_CFORM", I_CFORM);
            setField(function, "I_REENTRY", I_REENTRY);
            setField(function, "I_ORGKR", "X");//인사기록부 상 해외법인명 한글 표시되도록 flag(해당 값이 없으면 약어로만 보여줌)

            if("X".equals(I_CFORM))
                setField(function, "I_PTIMES", "20");


            excute( mConnection, function ) ;

            return getTable(B01ValuateDetailData.class, function, "T_LIST");

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

}
