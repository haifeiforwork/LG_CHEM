/**
 * A22ExecutiveProfileSV_m
 * �ӿ� profile �ҷ����� SV
 *
 *
 * @author  ������ 2016-05-30
 * @version 1.0 [CSR ID:3089281] �ӿ� 1Page �������� �ý��� ���� ��û�� ��.
 * 2017/09/08  [CSR ID:3460886] �ӿ� �������� �ý��� ���� ��û�� ��.
 * 2017/10/19   [CSR ID:3504688] Global Academy �����̷� I/F ���� ��û
 */
package servlet.hris.A.A22ExecutiveProfile;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A22resultOfProfileData;
import hris.A.rfc.A01SelfDetailRFC;
import hris.A.rfc.A02SchoolDetailRFC;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.A.rfc.A22resultOfProfileRFC;
import hris.C.C03LearnDetailData;
import hris.C.db.C03LearnDetailDB;
import hris.C.db.C03MapPernrData;
import hris.N.WebAccessLog;
import hris.common.WebUserData;
import hris.common.rfc.GetPhotoURLRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import servlet.hris.C.C03LearnDetailSV;

import java.util.Map;
import java.util.Vector;

public class A22ExecutiveProfileSV_m  extends EHRBaseServlet {


	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest  = "";
            String jobid2 = "";
            String licn_code = "";

            WebUserData user_m = WebUtil.getSessionMSSUser(req);



//          @����༺ �߰�
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }


            jobid2     = box.get("jobid2");

            if( jobid2.equals("") ){
                jobid2 = "first";
            }
            Logger.debug( "[jobid2] = "+jobid2);

            //String imgUrl ="";
            GetPhotoURLRFC      photofunc = null;  // ����
            A01SelfDetailRFC    selffunc  = null;  // ���λ���
//            A08LicenseDetailRFC licenfunc = null;  // �ڰݻ���
            A02SchoolDetailRFC  scholfunc = null;  // �з»���
            A04FamilyDetailRFC  familfunc = null;  // ��������
            Vector a01SelfDetailData_vt = new Vector();//���λ���
            Vector a22StrengthData_vt  = new Vector();// ����
            Vector a22LeadershipData_vt  = new Vector();// ������
            Vector a22resultOfThreeYear_vt = new Vector();// 3���� ��
            Vector a22busi_vt   = new Vector();
            Vector a22punish_vt    = new Vector();
            Vector a22edu_vt       = new Vector();
            Vector a22role_vt = new Vector();
            Vector a22career_vt = new Vector();
            Vector a22school_vt = new Vector();
            Vector a22language_vt = new Vector();
            Vector a22Info_vt = new Vector();


            /*******************
             * ���α� �޴� �ڵ��
             *******************/
            String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));
            if(sMenuCode.equals("")){
            	sMenuCode = "M120";//�ӿ� profile �޴��ڵ�
            }

            if ( user_m != null ) {

                // ������ũ
                photofunc = new GetPhotoURLRFC();
                //imgUrl = photofunc.getPhotoURL( user_m.empNo );

                // A01SelfDetailRFC ������������ ��ȸ
                selffunc = new A01SelfDetailRFC();
                a01SelfDetailData_vt = selffunc.getPersInfo(user_m.empNo, user.area.getMolga(), "");
                Logger.debug.println(this, "a01SelfDetailData_vt : "+ a01SelfDetailData_vt.toString());

                //����/������
                A22resultOfProfileRFC swfunc = new A22resultOfProfileRFC();
                Map<String, Vector> resultMap =  swfunc.getProfile(user_m.empNo);

                a22StrengthData_vt = resultMap.get("getPersInfoS");
                a22LeadershipData_vt = resultMap.get("getPersInfoW");
                //Logger.debug("!!!!!!!@@@@@@@@@@@@@@@ " +a22StrengthData_vt.get(1));
                //Logger.debug("!!!!!!!@@@@@@@@@@@@@@@ " +a22WeaknessData_vt.get(1));

                //3���� ��
                a22resultOfThreeYear_vt = resultMap.get("getResult3Year");

                //����� �ĺ�
                a22busi_vt = resultMap.get("getBusiness");

                //¡��
                a22punish_vt = resultMap.get("getPunish");

                //�ֿ� �����̷�
                a22edu_vt = resultMap.get("getEdu");

                /* [CSR ID:3504688] Global Academy �����̷� I/F ���� ��û start
                 * 1) ����� �ĺ� ���� ��ȸ
   						-  �ٽ�������� ������ �� ���������� �̼�, ����濵�� ���� ��õ ����
				   2) �����̷� ��ȸ
   						- �ӿ� �������� �̷� �� ���� �ֱ� 1�Ǹ� ��ȸ
				   3) ��� ��ȸ ����
     					- 1) + 2) ��ü ���� �ֽ� ���� ������ ���� (������ DESCENDING)
     					- ������('YY) ���·� ��ȸ, �������� ��� ',' �� ����
           				( ex:EnDP ���弱���� �̷��غ�('16) , ����濵�ڱ��� ��õ�ο�('04)  )
           	   */
                C03LearnDetailDB c03LearnDetailDB=   new C03LearnDetailDB();
                C03MapPernrData c03MapPernrData = C03LearnDetailSV.getMapPernr(g,  user_m.empNo,  "");
                Vector<C03LearnDetailData> resultList = c03LearnDetailDB.getImwonEduList(c03MapPernrData.PERNR);

                if(Utils.getSize(resultList)>0){
                	A22resultOfProfileData a22resultOfProfileData = new A22resultOfProfileData();
                	C03LearnDetailData c03LearnDetailData = Utils.indexOf(resultList, 0, C03LearnDetailData.class);
                	a22resultOfProfileData.CRESULT  = c03LearnDetailData.DVSTX+"('"+c03LearnDetailData.BEGDA.substring(2,4)+")";
                	a22resultOfProfileData.BEGDA = c03LearnDetailData.BEGDA;
                	a22edu_vt.add(a22resultOfProfileData);
                	a22edu_vt = SortUtil.sort( a22edu_vt, "BEGDA", "desc" ); //Vector Sort
                }
               //[CSR ID:3504688] Global Academy �����̷� I/F ���� ��û end
                //���ұ�
                a22role_vt = resultMap.get("getRole");

                //����
                //a22career_vt = resultMap.get("getCareer");

                //�з�
                a22school_vt = resultMap.get("getSchool");

              	//����
                a22language_vt = resultMap.get("getLang");

              	//�λ�⺻����
                a22Info_vt = resultMap.get("getInfo");

                String birthday = "";
                String geunsok = "";
                Double imwonAge = 0.0;
                Double geunsokAge = 0.0;
                A22resultOfProfileData dataInfo = new A22resultOfProfileData();
                if(a22Info_vt.size() != 0){
                    Logger.debug(a22Info_vt.get(0).getClass());
                	dataInfo = (A22resultOfProfileData)a22Info_vt.get(0);
                	birthday = dataInfo.GBDAT.replace("-", "");
                	geunsok = dataInfo.DAT01.replace("-", "");

                	imwonAge = getAgeFromBirthday(birthday.substring(0, 4),birthday.substring(4,6));
                	geunsokAge = getAgeFromBirthday(geunsok.substring(0, 4),geunsok.substring(4,6));
                }

                //req.setAttribute("imgUrl", imgUrl);
                req.setAttribute("a01SelfDetailData_vt", a01SelfDetailData_vt);
                req.setAttribute("a22StrengthData_vt", a22StrengthData_vt);
            	req.setAttribute("a22LeadershipData_vt", a22LeadershipData_vt);
            	req.setAttribute("a22busi_vt", a22busi_vt);
            	req.setAttribute("a22punish_vt", a22punish_vt);
            	req.setAttribute("a22edu_vt", a22edu_vt);
            	req.setAttribute("a22role_vt", a22role_vt);
            	req.setAttribute("a22career_vt", a22career_vt);
            	req.setAttribute("a22school_vt", a22school_vt);
            	req.setAttribute("a22language_vt", a22language_vt);
            	req.setAttribute("a22Info_vt", a22Info_vt);
            	req.setAttribute("imwonAge", imwonAge.toString());
            	req.setAttribute("geunsokAge", geunsokAge.toString());
            	req.setAttribute("a22resultOfThreeYear_vt", a22resultOfThreeYear_vt);

                req.setAttribute("actionList", resultMap.get("getAction"));
                req.setAttribute("sPlanList", resultMap.get("getSPlan"));
                req.setAttribute("sPlanListPost", resultMap.get("getSPlanPost"));//[CSR ID:3460886]

                if( jobid2.equals("first") ) {


                	dest = WebUtil.JspURL+"A/A22ExecutiveProfile/A22ExecutiveProfile_m.jsp";
                }else if(jobid2.equals("print") ){
                	/**
                	 * ���α� �߰� 2015-06-19
                	 * EADMIN �� EMANAG�� �����ϴ� ����ڴ� ���� �Ѵ�.
                	 * ������,���,�����ڴ� ���α� �߰� ������
                	 * MSS �μ����������� ��ȸ�ϴ� �޴��� ��� �߰���.
                	 *  session.setAttribute("remoteIP",remoteIP); IP�߰� �۾�
                	 *
                	 */

                	if(!user.user_group.equals("01") && !user.user_group.equals("02") && !user.user_group.equals("03")){
                        (new WebAccessLog()).setAccessLog(sMenuCode, user.empNo, user_m.empNo, user.remoteIP);
                	}
                	dest = WebUtil.JspURL+"A/A22ExecutiveProfile/A22ExecutiveProfilePrint.jsp";
                }else if(jobid2.equals("leader") ){//���� ������
                	req.setAttribute("a22resultOfThreeYear_vt", a22resultOfThreeYear_vt);
                	dest = WebUtil.JspURL+"N/orgstats/profilechart9.jsp";
                }else if(jobid2.equals("mission") ){//Mission
                	req.setAttribute("a22resultOfThreeYear_vt", a22resultOfThreeYear_vt);
                	dest = WebUtil.JspURL+"N/orgstats/profilechart10.jsp";
                } else {
                    throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
                }
            } else {
                //req.setAttribute("imgUrl", imgUrl);
                dest = WebUtil.JspURL+"A/A22ExecutiveProfile/A22ExecutiveProfile_m.jsp";
            }

            Logger.debug( " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        } finally {
        }
	}


	//���� ����ϱ�
	public static double getAgeFromBirthday(String yyyy,String mm) {
		Double year = Double.parseDouble(DataUtil.getCurrentYear())- Integer.parseInt(yyyy);
		Double month = Double.parseDouble(DataUtil.getCurrentMonth()) - Integer.parseInt(mm);
		Double result = 0.00;
		Double calcMonth = 0.00;
		if(month != 0.0){
			calcMonth = month/12;
			calcMonth = DataUtil.banolim(calcMonth,2);
		}
		result = year + calcMonth;
	    return result;
	}







}
