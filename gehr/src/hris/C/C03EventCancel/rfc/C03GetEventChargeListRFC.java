package hris.C.C03EventCancel.rfc;
 
import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.C.C03EventCancel.C03bapiReturnData;

/**
 * C03GetEventChargeListRFC.java
 * 교육취소신청 결재완료시 이벤트담당자에게 메일통보를 위한 통보자리스트 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2013/06/14 교육취소신청 결재 추가 | [요청번호]C20130627_58399
 */
public class C03GetEventChargeListRFC extends SAPWrap {

    private String functionName = "ZHRD_RFC_SERCH_PERNR_CHARGE";

    /**
     * 개인의 휴가신청 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getChargeList(String chaID ) throws GeneralException {

        JCO.Client mConnection = null;
        Vector vcRet = new Vector(); 

        C03bapiReturnData c03bapiReturnData = new C03bapiReturnData();  // RETURN CODE
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;


            setInput(function, chaID );
            excute(mConnection, function);
 
            Vector ListData = getTable( "hris.C.C03EventCancel.C03GetEventChargeListData", function, "IT_LIST" ); 
            getStructor( c03bapiReturnData, function, "RETURN");

            vcRet.add(ListData);
            vcRet.add(c03bapiReturnData);
            return vcRet;
             
            
        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
	
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String chaID) throws GeneralException {
        String fieldName1 = "IM_CHAID"          ;
        setField(function, fieldName1, chaID); 
    }
 
}
