/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalCardRFC                                          */
/*   Description  : 인사기록부 조회하는 RFC를 호출하는 Class                    */
/*   Note         :                                                             */
/*   Creation     : 2005-01-12  윤정현                                          */
/*   Update       :  구분추가 C20140210_84209                            */
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

            setField(function, "I_ECRGUB", "1");    //구분자 1 조회
            setField(function, "I_ECRKEY", I_ECRKEY);   //암호화 값 - 조회대상 값
            //setField(function, "I_NODEL", "X");   //암호화 값 - 조회대상 값  //운영 반영시 삭제


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
