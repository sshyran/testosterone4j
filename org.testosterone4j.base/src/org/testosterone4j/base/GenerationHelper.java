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

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.List;

public class GenerationHelper {

	public static boolean activeGeneration = false;

	public synchronized List<Object[]> readOrGenerateTestCases(final String fileName, final Generator generator,
			final Class<? extends Runnable> testClass) {
		List<?> testCases = null;

		final File f = new File(fileName);

		// if (!f.exists()) {
		if (true) {
			testCases = generateTestCases(generator, testClass, f);
		} else {
			try {
				testCases = readSerialization(testClass, f);
			} catch (final Exception ex) {
				testCases = generateTestCases(generator, testClass, f);
			}
		}
		final List<Object[]> testCaseConfig = new ArrayList<Object[]>();
		int i = 1;
		for (final Object testCase : testCases) {
			testCaseConfig.add(new Object[] { new TestDescriptor(i++, (BaseUseCase) testCase) });
		}
		return testCaseConfig;
	}

	private List<?> generateTestCases(final Generator generator, final Class<? extends Runnable> testClass, final File f) {
		List<?> testCases;
		activeGeneration = true;
		testCases = generate(generator, testClass);
		activeGeneration = false;
		/*
		 * try { writeSerialization(testCases, testClass, f); } catch (final IOException e) { throw new RuntimeException(
		 * "Cannot write generated test data to file!", e); }
		 */
		return testCases;
	}

	public List<?> generate(final Generator generator, final Class<? extends Runnable> clazz) {
		return generator.generate(clazz);
	}

	private List<Object> readSerialization(final Class<?> useCaseClass, final File f) throws IOException, ClassNotFoundException {
		final ObjectInputStream oin = new ObjectInputStream(new FileInputStream(f));
		Object o = null;
		final List<Object> list = new ArrayList<Object>();
		while ((o = oin.readObject()) != null) {
			list.add(o);
		}
		return list;

		// JAXBContext context = JAXBContext.newInstance(UseCaseSuite.class,
		// useCaseClass);
		// Unmarshaller um = context.createUnmarshaller();
		// UseCaseSuite<?> suite = (UseCaseSuite<?>) um.unmarshal(f);
		// return suite.getTestCases();
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void writeSerialization(final List<?> testCases, final Class<?> useCaseClass, final File f) throws IOException {
		final ObjectOutputStream oout = new ObjectOutputStream(new FileOutputStream(f));
		for (final Object testCase : testCases) {
			oout.writeObject(testCase);
		}
		oout.writeObject(null);
	}

}
