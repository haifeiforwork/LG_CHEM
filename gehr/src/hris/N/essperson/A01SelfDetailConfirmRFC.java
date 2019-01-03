/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 메뉴                                                        */
/*   Program Name : 메뉴                                                        */
/*   Program ID   :A01SelfDetailConfirmRFC.java                                        */
/*   Description  : 메뉴 목록 가져오기                                          */
/*   Note         : [관련 RFC] : A01SelfDetailConfirmRFC                         */
/*   Creation     : 2016 1.1  [CSR ID:2953938] 개인 인사정보 확인기능 구축 및 반영의 件                                            */
/*   Update       :    */
/*                                                                              */
/********************************************************************************/

package hris.N.essperson;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

public class A01SelfDetailConfirmRFC extends SAPWrap {

    private String functionName = "ZGHR_INFORMATION_CONFIRM";

    /**
     *
1. IMPORT
PERNR TYPE PERNR-PERNR                       사원 번호
GUBUN TYPE CHAR01                       'C' = 확인 구분, 'S' = 여부 구분
CFLAG TYPE CHAR01                       'Y' = 확인 완료

2. EXPORT
CONFIRM TYPE CHAR1 'Y' = 확인 완료
 -------------------------------------------------------------------------------
1. 확인 대상자 여부 처리
 : 사번(PERNR)과 구분자(GUBUN = 'S' )에 값을 넘겨주면 CONFIRM 필드로 RETURN 함
   CONFIRM의 값이 'Y' 이면 팝업 대상자임

2. 개인이 팝업에서 확인 버튼을 눌렀을 경우
  : 사번(PERNR)과 구분자(GUBUN = 'C') 확인완료(CFLAG = 'Y')에 값을 넘겨주면 SAP에 업데이트 함
    MESSAGE 필드에 '확인이 완료되었습니다.'로 RETURN 함
 -------------------------------------------------------------------------------
     */
    public String getInsaConfirmTargetCheck(String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            /*
            I_PERNR		 NUMC 	 8 	사원번호
I_GUBUN		 CHAR 	 1 	구분자
I_CFLAG		 CHAR 	 1 	확인완료
             */
            setField( function, "I_PERNR", I_PERNR );
            setField( function, "I_GUBUN", "S");

            excute(mConnection, function);

            return getField("E_CONFIRM", function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public RFCReturnEntity setInsaConfirmEnd(String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR", I_PERNR );
            setField( function, "I_GUBUN", "C");
            setField( function, "I_CFLAG", "Y");

            excute(mConnection, function);

            return getReturn();

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}
