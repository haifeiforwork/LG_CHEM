package hris.E.E17Hospital;

import com.sns.jdf.EntityData;

import java.util.Vector;

/**
 * Created by manyjung on 2016-10-13.
 */
public class E17HospitalResultData extends EntityData {

    public Vector<E17SickData> T_ZHRA006T;
    public Vector<E17HospitalData> T_ZHRW005A;
    public Vector<E17BillData> T_ZHRW006A;

    public String E_LASTDAY ;  // 동일질병 마지막 신청일
    public String E_YEARS ;  // 나이 년수
    public String E_MNTH  ;  // 나이 월수

    public Vector<E17SickData> getT_ZHRA006T() {
        return T_ZHRA006T;
    }

    public void setT_ZHRA006T(Vector<E17SickData> t_ZHRA006T) {
        T_ZHRA006T = t_ZHRA006T;
    }

    public Vector<E17HospitalData> getT_ZHRW005A() {
        return T_ZHRW005A;
    }

    public void setT_ZHRW005A(Vector<E17HospitalData> t_ZHRW005A) {
        T_ZHRW005A = t_ZHRW005A;
    }

    public Vector<E17BillData> getT_ZHRW006A() {
        return T_ZHRW006A;
    }

    public void setT_ZHRW006A(Vector<E17BillData> t_ZHRW006A) {
        T_ZHRW006A = t_ZHRW006A;
    }

    public String getE_LASTDAY() {
        return E_LASTDAY;
    }

    public void setE_LASTDAY(String e_LASTDAY) {
        E_LASTDAY = e_LASTDAY;
    }

    public String getE_YEARS() {
        return E_YEARS;
    }

    public void setE_YEARS(String e_YEARS) {
        E_YEARS = e_YEARS;
    }

    public String getE_MNTH() {
        return E_MNTH;
    }

    public void setE_MNTH(String e_MNTH) {
        E_MNTH = e_MNTH;
    }
}
