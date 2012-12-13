package de.msg.xt.mdt.tdsl.sampleProject.template.test.usecase;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import de.msg.xt.mdt.base.AbstractActivity;
import de.msg.xt.mdt.base.Generator;
import de.msg.xt.mdt.tdsl.sampleProject.template.test.activity.AnotherSampleActivity;
import de.msg.xt.mdt.tdsl.sampleProject.template.test.activity.OtherSampleActivity;
import de.msg.xt.mdt.tdsl.sampleProject.template.test.activity.SampleActivity;
import de.msg.xt.mdt.tdsl.sampleProject.template.test.datatype.Sachnummer;
import de.msg.xt.mdt.tdsl.sampleProject.template.test.datatype.StringDT;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement
public class SampleUseCase implements Runnable {

    @XmlElement
    private StringDT inputParam1;

    @XmlElement
    private Sachnummer inputParam2;

    @XmlElement
    private SampleSubUseCase subUseCase;

    @XmlTransient
    private Generator generator;

    public SampleUseCase() {
    }

    public SampleUseCase(Generator generator) {
        this.generator = generator;
    }

    public SampleUseCase(StringDT inputParam1, Sachnummer inputParam2, SampleSubUseCase subUseCase) {
        this.inputParam1 = inputParam1;
        this.inputParam2 = inputParam2;
        this.subUseCase = subUseCase;
    }

    @Override
    public void run() {
        execute(SampleActivity.find());
    }

    public void execute(SampleActivity initialActivity) {
        AbstractActivity activity = initialActivity;
        activity = ((SampleActivity) activity).description_setText(getInputParam1());
        if (((SampleActivity) activity).isEnabled_description_invokeAction_1()) {
            OtherSampleActivity activity2 = ((SampleActivity) activity).description_invokeAction_1();
            getSubUseCase().execute(activity2);
        } else if (((SampleActivity) activity).isEnabled_description_invokeAction_2()) {
            AnotherSampleActivity activity3 = ((SampleActivity) activity).description_invokeAction_2();
            activity3.setAdress("Gunta-Stölzl-Str. 5");
        }
    }

    public StringDT getInputParam1() {
        if (this.inputParam1 == null && this.generator != null) {
            this.inputParam1 = this.generator.generateDataTypeValue(StringDT.class, "SampleUseCase_inputParam1");
        }
        return this.inputParam1;
    }

    public SampleSubUseCase getSubUseCase() {
        if (this.subUseCase == null && this.generator != null) {
            this.subUseCase = new SampleSubUseCase(this.generator);
        }
        return this.subUseCase;
    }
}