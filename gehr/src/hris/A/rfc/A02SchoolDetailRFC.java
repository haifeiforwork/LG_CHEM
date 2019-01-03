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
 * 학력사항 List 를 가져오는 RFC를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2001/12/17
 */
public class A02SchoolDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_EDUCATION_LIST";

    //sapType을 바꾸고자 할때 start
    /*public A02SchoolDetailRFC(SAPType sapType) {
        super(sapType);
    }*/
  //sapType을 바꾸고자 할때 end

    public A02SchoolDetailRFC() {
    }
    /**
     * 학력사항 List 를 가져오는 RFC를 호출하는 Method
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
          //sapType을 바꾸고자 할때 start
            //SapType을 바꾸고자 할때 molga값도 바뀌어야 하는데 SapWrap에서 세션값을 넘기므로 따로 지정해줌
            /*userMolga.setArea(Area.KR);
            excute(mConnection, function,userMolga);*/
          //sapType을 바꾸고자 할때 end
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

