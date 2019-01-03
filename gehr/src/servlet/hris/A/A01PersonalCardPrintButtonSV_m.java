/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalCardSV_m.java                                    */
/*   Description  : 인사기록부 조회 및 출력하는 class                           */
/*   Note         :                                                             */
/*   Creation     : 2005-01-12  윤정현                                          */
/*   Update       :  구분추가 C20140210_84209                            */
/*   Update       :  2014/05/30 이지은   [CSR ID:2553584]  인사기록부 출력방식 변경(PDF)                            */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.PersonalCardInterfaceData;
import hris.A.PersonalCardInterfacePersonData;
import hris.N.AES.AESgenerUtil;
import org.apache.commons.lang.StringUtils;
import servlet.hris.N.mssperson.A01SelfDetailNeoSV_m;
import servlet.hris.SApMSSViewSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A01PersonalCardPrintButtonSV_m extends A01SelfDetailNeoSV_m {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            Box box = WebUtil.getBox(req);

            try {

                PersonalCardInterfaceData interfaceData = (PersonalCardInterfaceData) req.getSession().getAttribute(SApMSSViewSV.SAP_INTERFACE);

                if(interfaceData != null) {
                    String viewEmpno = box.get("viewEmpno");
                    String empno = WebUtil.getSessionMSSUser(req).empNo;

                    if(StringUtils.isNotBlank(viewEmpno))
                        empno = AESgenerUtil.decryptAES(box.get("viewEmpno"));

            /* M 권한 확인 */
                    /*if (!checkAuthorization(req, res)) return;*/

            /* 대상 권한 확인 */
                    /*if (checkBelongPerson(req, res, empno, box.get("I_RETIR"))) {*/

            /* MSS 사용자 정보 확인 및 세션 생성 */
                    if (StringUtils.isNotBlank(viewEmpno) && !setUserSession(empno, req)) {
                        moveMsgPage(req, res, g.getMessage("MSG.COMMON.0083"), "history.back();");
                        return;
                    }
                    /*} else return;*/

                    Vector<PersonalCardInterfacePersonData> personDataList = interfaceData.getPersonDataList();
                    int nSize = Utils.getSize(personDataList);

                    if(nSize > 0) {
                        String prevPerson = "";
                        String nextPerson = "";
                        for (int n = 0; n < nSize; n++) {
                            PersonalCardInterfacePersonData personData = personDataList.get(n);
                            if (StringUtils.equals(empno, personData.getPERNR())) {
                                PersonalCardInterfacePersonData next;
                                if (n + 1 < nSize) {
                                    nextPerson = personDataList.get(n + 1).getPERNR();
                                } else {
                                    nextPerson = personDataList.get(0).getPERNR();
                                }
                                break;
                            } else {
                                prevPerson = personData.getPERNR();
                            }
                        }

                        if (StringUtils.isBlank(prevPerson)) prevPerson = personDataList.get(0).getPERNR();

                        req.setAttribute("prevPerson", AESgenerUtil.encryptAES(prevPerson));
                        req.setAttribute("nextPerson", AESgenerUtil.encryptAES(nextPerson));
                    }
                }

                req.setAttribute("interfaceData", interfaceData);

            } catch(Exception e) {
                Logger.error(e);
            }

            printJspPage(req, res, WebUtil.JspURL+"common/printTopPopUp_insa.jsp");

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
