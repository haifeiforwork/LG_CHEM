package hris.common.rfc;

import hris.common.SchoolData;

import java.util.Vector;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * SchoolRFC.java
 * 학교정보 RFC를 호출하는  Class
 *[CSR ID:2634836] 학자금 신청 시스템 개발 요청
 * @author SJY
 * @version 1.0, 2014/10/23
 */
public class SchoolRFC extends SAPWrap {

	//private String functionName = "ZHRW_RFC_SCHOOL_SELECT_LIST";
	private String functionName = "ZGHR_RFC_SCHOOL_SELECT_LIST";

	/**
	 * 검색한 대학교리스트를 가져오는 method
	 * @param String i_pernr
	 * @param String i_ename
	 * @param String i_shool
	 * @return Vector
	 * @throws GeneralException
	 */
	public Vector getSchool( String i_pernr, String i_ename, String i_shool ) throws GeneralException {
		JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr, i_ename, i_shool);
            excute(mConnection, function);
            Vector ret = getTable(SchoolData.class, function, "T_RESULT"); //getOutput(function);

            return ret;
        } catch(Exception ex){
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String cName, String schoolName) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo ); //작성자 사번
        String fieldName2 = "I_NAME";
        setField( function, fieldName2, cName ); //작성자 자녀이름
        String fieldName3 = "I_SCHNAME";
        setField( function, fieldName3, schoolName ); //검색한 학교명
    }

}
