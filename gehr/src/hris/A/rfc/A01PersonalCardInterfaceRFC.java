/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �λ�������ȸ                                                */
/*   Program Name : �λ��Ϻ� ��ȸ �� ���                                     */
/*   Program ID   : A01PersonalCardRFC                                          */
/*   Description  : �λ��Ϻ� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class                    */
/*   Note         :                                                             */
/*   Creation     : 2005-01-12  ������                                          */
/*   Update       :  �����߰� C20140210_84209                            */
/*                                                                              */
/********************************************************************************/

package hris.A.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;
import hris.A.PersonalCardInterfaceData;
import hris.A.PersonalCardInterfaceMainData;
import hris.A.PersonalCardInterfacePersonData;

public class A01PersonalCardInterfaceRFC extends SAPWrap {

    private  static String functionName = "ZGHR_RFC_PERSONNEL_CARD_INTF";

    public A01PersonalCardInterfaceRFC(SAPType sapType) {
        super(sapType);
    }

    public A01PersonalCardInterfaceRFC() {
    }

    public PersonalCardInterfaceData getPersonalCardInterfaceData(String I_ECRKEY) throws GeneralException {
        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ECRGUB", "1");    //������ 1 ��ȸ
            setField(function, "I_ECRKEY", I_ECRKEY);   //��ȣȭ �� - ��ȸ��� ��
            //setField(function, "I_NODEL", "X");   //��ȣȭ �� - ��ȸ��� ��  //� �ݿ��� ����


            excute(mConnection, function);

            PersonalCardInterfaceData resultData = new PersonalCardInterfaceData();
            resultData.mainList = getTable(PersonalCardInterfaceMainData.class, function, "T_MAIN");
            resultData.personDataList = getTable(PersonalCardInterfacePersonData.class, function, "T_PERSON");

            return resultData;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}
