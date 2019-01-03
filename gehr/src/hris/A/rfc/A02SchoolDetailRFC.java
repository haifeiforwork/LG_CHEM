package hris.A.rfc;

import com.common.constant.Area;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A02SchoolData;
import hris.common.WebUserData;

import java.util.Vector;

/**
 * A02SchoolDetailRFC.java
 * �з»��� List �� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ڿ���
 * @version 1.0, 2001/12/17
 */
public class A02SchoolDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_EDUCATION_LIST";

    //sapType�� �ٲٰ��� �Ҷ� start
    /*public A02SchoolDetailRFC(SAPType sapType) {
        super(sapType);
    }*/
  //sapType�� �ٲٰ��� �Ҷ� end

    public A02SchoolDetailRFC() {
    }
    /**
     * �з»��� List �� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A02SchoolData> getSchoolDetail( String I_PERNR, String I_MOLGA, String I_CFORM) throws GeneralException {
        return getSchoolDetail(I_PERNR, I_MOLGA, I_CFORM, null);
    }

    public Vector<A02SchoolData> getSchoolDetail( String I_PERNR, String I_MOLGA, String I_CFORM, String I_GRAD) throws GeneralException {

        JCO.Client mConnection = null;
        Vector<A02SchoolData> resultList = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_MOLGA", I_MOLGA);
            setField(function, "I_CFORM", I_CFORM);
            WebUserData userMolga = new WebUserData();

            if(I_GRAD != null) setField(function, "I_GRAD", I_GRAD);
          //sapType�� �ٲٰ��� �Ҷ� start
            //SapType�� �ٲٰ��� �Ҷ� molga���� �ٲ��� �ϴµ� SapWrap���� ���ǰ��� �ѱ�Ƿ� ���� ��������
            /*userMolga.setArea(Area.KR);
            excute(mConnection, function,userMolga);*/
          //sapType�� �ٲٰ��� �Ҷ� end
            excute(mConnection, function);

            resultList = getTable(A02SchoolData.class, function, "T_LIST");
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }

        return resultList;
    }

}

