package hris.A.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A01SelfDetailData;

import java.util.Vector;

/**
 * A01PersInfoRFC.java
 * ��������������ȸ�ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2001/12/17
 *   update [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18
 *   2018/05/21 rdcamel [CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
 */
public class A01SelfDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_PERSONEL_HEADER";
 // [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18
    private String functionNameM = "ZGHR_RFC_PERSONEL_HEADER_M";

    /**
     * ��������������ȸ�ϴ� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A01SelfDetailData> getPersInfo(String I_PERNR, String I_MOLGA, String I_CFORM) throws GeneralException {

        JCO.Client mConnection = null;
        Vector<A01SelfDetailData> resultList = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_MOLGA", I_MOLGA);
            setField(function, "I_CFORM", I_CFORM);

            excute(mConnection, function);

            resultList = getTable(A01SelfDetailData.class, function, "T_HEADER");
        } catch(Exception ex) {
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }

        return resultList;
    }
    
    
    /**
     * ��������������ȸ�ϴ� RFC�� ȣ���ϴ� Method(���� ��� ���� text �߰�����)
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * @author rdcamel [CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
     */
    public Vector<A01SelfDetailData> getPersInfoLong(String I_PERNR, String I_MOLGA, String I_CFORM) throws GeneralException {

        JCO.Client mConnection = null;
        Vector<A01SelfDetailData> resultList = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_MOLGA", I_MOLGA);
            setField(function, "I_CFORM", I_CFORM);
            setField(function, "I_ORGKR", "X");//�λ��Ϻ� �� �ؿܹ��θ� �ѱ� ǥ�õǵ��� flag(�ش� ���� ������ ���θ� ������)

            excute(mConnection, function);

            resultList = getTable(A01SelfDetailData.class, function, "T_HEADER");
        } catch(Exception ex) {
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }

        return resultList;
    }
    
    // [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 start
    public Vector<A01SelfDetailData> getPersInfoM(String I_PERNR, String I_MOLGA, String I_CFORM) throws GeneralException {

        JCO.Client mConnection = null;
        Vector<A01SelfDetailData> resultList = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionNameM) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_MOLGA", I_MOLGA);
            setField(function, "I_CFORM", I_CFORM);

            excute(mConnection, function);

            resultList = getTable(A01SelfDetailData.class, function, "T_HEADER");
        } catch(Exception ex) {
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }

        return resultList;
    }
 // [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 end
}

