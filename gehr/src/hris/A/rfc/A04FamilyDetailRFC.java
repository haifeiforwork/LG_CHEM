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
 * �������� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2001/12/17
 */
public class A04FamilyDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_FAMILY_LIST";

    /**
     * �������� ������ �������� RFC�� ȣ���ϴ� Method
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
            I_GTYPE	TYPE	ZEHRGTYPE	'1'	ó������
I_PERNR	TYPE	PERSNO	                     	��� ��ȣ
I_SUBTY	TYPE	SUBTY	                     	���� ����
I_OBJPS	TYPE	OBJPS	                     	������Ʈ�ĺ�
I_MOLGA	TYPE	MOLGA	                     	���� �׷���
I_DATUM	TYPE	DATUM	SY-DATLO	����
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