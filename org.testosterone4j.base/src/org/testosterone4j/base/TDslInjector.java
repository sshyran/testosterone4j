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


import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.Module;

public class TDslInjector {

	private static Injector instance = null;

	public static Injector getInjector() {
		return instance;
	}

	public static Injector createInjector(String testID) {
		String moduleClass = System.getProperty("module");
		if (moduleClass == null) {
			throw new IllegalArgumentException(
					"A guice module must be specified!");
		}
		try {
			Constructor<?> constructor = Class.forName(moduleClass)
					.getConstructor(String.class);
			Module module = (Module) constructor.newInstance(testID);
			instance = Guice.createInjector(module);
		} catch (InstantiationException e) {
			throw new IllegalArgumentException(
					"Cannot instantiate specified guice module!");
		} catch (IllegalAccessException e) {
			throw new IllegalArgumentException(
					"Cannot instantiate specified guice module!");
		} catch (ClassNotFoundException e) {
			throw new IllegalArgumentException(
					"Cannot find specified guice module class!");
		} catch (NoSuchMethodException e) {
			throw new IllegalArgumentException(
					"Specified guice module class does not have a String constructor!");
		} catch (SecurityException e) {
			throw new IllegalArgumentException(
					"Cannot instantiate specified guice module!");
		} catch (IllegalArgumentException e) {
			throw new IllegalArgumentException(
					"Cannot instantiate specified guice module!");
		} catch (InvocationTargetException e) {
			throw new IllegalArgumentException(
					"Cannot instantiate specified guice module!");
		}
		return instance;
	}
}
