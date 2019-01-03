package hris.A;

import com.common.Utils;
import com.sns.jdf.EntityData;
import org.apache.commons.lang.StringUtils;

import java.util.Vector;

/**
 * Created by manyjung on 2016-12-19.
 */
public class PersonalCardInterfaceData extends EntityData {

    public Vector<PersonalCardInterfaceMainData> mainList;

    public Vector<PersonalCardInterfacePersonData> personDataList;

    public String E_ECRKEY; //ªÍ√‚≈∞

    public String getE_ECRKEY() {
        return E_ECRKEY;
    }

    public PersonalCardInterfaceMainData getMain() {
        return Utils.indexOf(mainList, 0, PersonalCardInterfaceMainData.class);
    }

    public void setE_ECRKEY(String e_ECRKEY) {
        E_ECRKEY = e_ECRKEY;
    }

    public Vector<PersonalCardInterfaceMainData> getMainList() {
        return mainList;
    }

    public void setMainList(Vector<PersonalCardInterfaceMainData> mainList) {
        this.mainList = mainList;
    }

    public Vector<PersonalCardInterfacePersonData> getPersonDataList() {
        return personDataList;
    }

    public void setPersonDataList(Vector<PersonalCardInterfacePersonData> personDataList) {
        this.personDataList = personDataList;
    }

    public PersonalCardInterfacePersonData getFirstPersonData() {
        return Utils.indexOf(personDataList, 0, PersonalCardInterfacePersonData.class);
    }

    public PersonalCardInterfacePersonData getPersonData(String pernr) {

        for(PersonalCardInterfacePersonData row : personDataList) {
            if(StringUtils.equals(row.getPERNR(), pernr)) return row;
        }

        return new PersonalCardInterfacePersonData();
    }

}
