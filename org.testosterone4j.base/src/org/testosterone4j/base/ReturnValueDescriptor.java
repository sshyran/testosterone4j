package org.testosterone4j.base;

/*
 * #%L
 * org.testosterone4j.base
 * %%
 * Copyright (C) 2015 Axel Ruder
 * %%
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * #L%
 */

import java.util.Map;

public class ReturnValueDescriptor<T> {

    private T returnValue;

    private AbstractActivity nextActivity;

    private Map<String, DataType> generatedData;

    public ReturnValueDescriptor(T returnValue, AbstractActivity nextActivity, Map<String, DataType> generatedData) {
        super();
        this.returnValue = returnValue;
        this.nextActivity = nextActivity;
        this.generatedData = generatedData;
    }

    public T getReturnValue() {
        return this.returnValue;
    }

    public void setReturnValue(T returnValue) {
        this.returnValue = returnValue;
    }

    public AbstractActivity getNextActivity() {
        return this.nextActivity;
    }

    public void setNextActivity(AbstractActivity nextActivity) {
        this.nextActivity = nextActivity;
    }

    public Map<String, DataType> getGeneratedData() {
        return this.generatedData;
    }

    public void setGeneratedData(Map<String, DataType> generatedData) {
        this.generatedData = generatedData;
    }

}
