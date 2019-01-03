/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족사항 추가입력                                           */
/*   Program Name : 가족사항 추가입력                                           */
/*   Program ID   : A12FamilyChangeSV                                           */
/*   Description  : 가족사항 신청을 수정할 수 있도록 하는 Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-01-28  김도신                                          */
/*   Update       : 2005-03-03  윤정현                                          */
/*                      2018/01/07 rdcamel [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건                                                         */
/********************************************************************************/

package servlet.hris.A.A12Family;

import com.common.Utils;
import com.common.constant.Area;
import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.A.A04FamilyDetailData;
import hris.A.A12Family.A12FamilyListData;
import hris.A.A12Family.rfc.*;
import hris.A.A13Address.rfc.A13AddressNationRFC;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.Map;
import java.util.Vector;

public class A12FamilyChangeSV extends EHRBaseServlet {
    
    //private String UPMU_TYPE ="12";
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;
        
        try{
            WebUserData user = WebUtil.getSessionUser(req);
            
            String dest  = "";
            String jobid = "";
            String PERNR;


            Box box = WebUtil.getBox(req);

            jobid = box.get("jobid", "first");
            String subty = box.get("SUBTY");
            String objps = box.get("OBJPS");

            Vector  a12FamilyListData_vt = new Vector();
            
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            //개인정보 신규tab메뉴 추가
            String subView = WebUtil.nvl(box.get("subView"));
            
            /******************************
             * 
             * @$ 웹보안진단 marco257
             * 대리신청 권한체크 추가
             * user.e_representative;
             * 
             ******************************/
            
            PERNR = getPERNR(box, user);
            box.put("I_PERNR", PERNR);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);

            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );
            req.setAttribute("isUpdate", true);

            if( jobid.equals("first") ) {   // 제일처음 수정 화면에 들어온경우.

                box.put("I_SUBTY", box.get("SUBTY"));
                box.put("I_OBJPS", box.get("OBJPS"));

                A04FamilyDetailRFC func1 = new A04FamilyDetailRFC();
                Vector a04FamilyDetailData_vt = func1.getFamilyDetail(box);
                
                if (user.area == Area.KR) {
                    box.put("I_SUBTY", "");
                    box.put("I_OBJPS", "");
                    req.setAttribute("a04FamilyDetailData_vt", func1.getFamilyDetail(box));

                    req.setAttribute("familyRelationList", (new A12FamilyRelationRFC()).getFamilyRelation(""));
                    req.setAttribute("scholarShipList", (new A12FamilyScholarshipRFC()).getFamilyScholarship());

                    Vector<CodeEntity> subTypeList = (new A12FamilySubTypeRFC()).getFamilySubType();
                    subTypeList = new Vector<CodeEntity>(Collections2.filter(subTypeList, new Predicate<CodeEntity>() {
                        public boolean apply(CodeEntity codeEntity) {
                            return !StringUtils.equals("15", codeEntity.code);
                        }
                    }));
                    req.setAttribute("subTypeList", subTypeList);

                } else {
                    req.setAttribute("subTypeList", (new A12FamilyListRFC()).getFamilySubType(user.e_area));

                    Map familyEntry = ((new A12FamilyUtil()).getElements(user.empNo));
                    req.setAttribute("familyEntry", familyEntry.get("T_ITAB"));
                    req.setAttribute("familyEntry1", familyEntry.get("T_ITAB1"));
                    req.setAttribute("familyEntry4", familyEntry.get("T_ITAB4"));
                }


                req.setAttribute("PERNR", PERNR);
                req.setAttribute("PersonData", phonenumdata);
                req.setAttribute("PhoneNumData2", phonenumdata);
                req.setAttribute("a04FamilyDetailData", Utils.indexOf(a04FamilyDetailData_vt, 0));

                req.setAttribute("nationList", (new A13AddressNationRFC()).getAddressNation());

                if (Arrays.asList(Area.KR.getMolga(), Area.CN.getMolga(), Area.HK.getMolga(), Area.TW.getMolga()).contains(phonenumdata.getE_MOLGA())) {
                    dest = WebUtil.JspURL + "A/A12Family/A12FamilyBuild_" + user.area + ".jsp";
//                    dest = WebUtil.JspURL + "A/A12Family/A12FamilyBuild_HK.jsp";
                    printJspPage(req, res, dest);
                } else {
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0060"), "history.back();"); //페이지에 권한이 없습니다.
                    return;
                }


            } else if( jobid.equals("change") ) {   // 가족사항 리스트화면에서 수정버튼 클릭..
                
                A12FamilyListRFC   rfc                  = new A12FamilyListRFC();
                A04FamilyDetailData  a12FamilyListData    = new A04FamilyDetailData();//[CSR ID:3569665] 
                
                // 주소 입력
                box.copyToEntity(a12FamilyListData);
                a12FamilyListData.PERNR  = PERNR;                                  // 사번
                a12FamilyListData.REGNO  = DataUtil.removeSeparate(box.get("REGNO"));   // 주민등록번호
                
                a12FamilyListData_vt.addElement(a12FamilyListData);
                
                Logger.debug.println(this, "가족사항 수정 데이터 : " + a12FamilyListData_vt.toString());
                
                // 수정 RFC Call
                rfc.change(PERNR, subty, objps, a12FamilyListData_vt);
                
                String msg = "msg002";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A04FamilyDetailSV?subView="+subView+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                
                dest = WebUtil.JspURL+"common/msg.jsp";
                printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            
            Logger.debug.println(this, " destributed = " + dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            
        }
    }
    
}