package	hris.A.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.servlet.Box;
import hris.A.A04FamilyDetailData;

import java.util.Vector;

/**
 * A04FamilyDetailRFC.java
 * 가족사항 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2001/12/17
 */
public class A04FamilyDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_FAMILY_LIST";

    /**
     * 가족사항 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A04FamilyDetailData> getFamilyDetail(Box box) throws GeneralException {
    
        JCO.Client mConnection = null;

        Vector<A04FamilyDetailData> resultList = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            /*
            I_GTYPE	TYPE	ZEHRGTYPE	'1'	처리구분
I_PERNR	TYPE	PERSNO	                     	사원 번호
I_SUBTY	TYPE	SUBTY	                     	하위 유형
I_OBJPS	TYPE	OBJPS	                     	오브젝트식별
I_MOLGA	TYPE	MOLGA	                     	국가 그루핑
I_DATUM	TYPE	DATUM	SY-DATLO	일자
I_SPRSL	TYPE	SPRAS	SY-LANGU
             */
            setFieldForLData(function, box);
            setField(function, "I_GTYPE", "1");

            excute(mConnection, function);

            resultList = getTable(A04FamilyDetailData.class, function, "T_LIST");

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }

        return resultList;
    }

}