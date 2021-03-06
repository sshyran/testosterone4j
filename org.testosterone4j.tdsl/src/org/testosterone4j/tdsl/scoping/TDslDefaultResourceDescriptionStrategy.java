package org.testosterone4j.tdsl.scoping;

/*
 * #%L
 * org.testosterone4j.tdsl
 * %%
 * Copyright (C) 2015 Axel Ruder
 * %%
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * #L%
 */

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.EcoreUtil2;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.resource.EObjectDescription;
import org.eclipse.xtext.resource.IDefaultResourceDescriptionStrategy;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.resource.impl.DefaultResourceDescriptionStrategy;
import org.eclipse.xtext.util.CancelIndicator;
import org.eclipse.xtext.util.IAcceptor;
import org.testosterone4j.tdsl.tDsl.Activity;
import org.testosterone4j.tdsl.tDsl.ActivityOperationParameterAssignment;
import org.testosterone4j.tdsl.tDsl.ConditionalNextActivity;
import org.testosterone4j.tdsl.tDsl.DataType;
import org.testosterone4j.tdsl.tDsl.EquivalenceClass;
import org.testosterone4j.tdsl.tDsl.OperationParameterAssignment;
import org.testosterone4j.tdsl.tDsl.PackageDeclaration;
import org.testosterone4j.tdsl.tDsl.ParameterAssignment;
import org.testosterone4j.tdsl.tDsl.StatementLine;
import org.testosterone4j.tdsl.tDsl.TagWithCondition;
import org.testosterone4j.tdsl.tDsl.TagsDeclaration;
import org.testosterone4j.tdsl.tDsl.Test;
import org.testosterone4j.tdsl.tDsl.Toolkit;

public class TDslDefaultResourceDescriptionStrategy extends
		DefaultResourceDescriptionStrategy implements
		IDefaultResourceDescriptionStrategy {

	@Inject
	IQualifiedNameProvider nameProvider;

	/**
	 * PackageDeclaration Import Test TagsDeclaration EquivalenceClass
	 * TagWithCondition ConditionalNextActivity ParameterAssignment
	 * OperationParameterAssignment ActivityOperationParameterAssignment
	 * StatementLine
	 */
	@Override
	public boolean createEObjectDescriptions(final EObject eObject,
			final IAcceptor<IEObjectDescription> acceptor) {
		if (eObject instanceof DataType) {
			final DataType dt = (DataType) eObject;
			final Map<String, String> userData = new HashMap<String, String>();
			userData.put("isDefault", dt.isDefault() ? "true" : "false");
			createDescription(acceptor, dt, userData);
			return true;
		} else if (eObject instanceof PackageDeclaration) {
			return true;
		} else if (eObject instanceof Test) {
			return false;
		} else if (eObject instanceof TagsDeclaration) {
			return true;
		} else if (eObject instanceof EquivalenceClass) {
			return false;
		} else if (eObject instanceof TagWithCondition) {
			return false;
		} else if (eObject instanceof ConditionalNextActivity) {
			return false;
		} else if (eObject instanceof ParameterAssignment) {
			return false;
		} else if (eObject instanceof OperationParameterAssignment) {
			return false;
		} else if (eObject instanceof ActivityOperationParameterAssignment) {
			return false;
		} else if (eObject instanceof StatementLine) {
			return false;
		} else if (eObject instanceof Toolkit) {
			return super.createEObjectDescriptions(eObject, acceptor);
		} else {
			return super.createEObjectDescriptions(eObject, acceptor);
		}
	}

	private void addConditionalNextActivityToUserData(
			final Map<String, String> userData,
			final ConditionalNextActivity condNextAct) {
		final Activity nextActivity = condNextAct.getNext();
		if (nextActivity != null) {
			resolveObject(nextActivity);
			final URI nextActivityUri = EcoreUtil2.getURI(nextActivity);
			if (nextActivityUri.toString().contains("xtextLink")) {
				System.out.println("Putting URI " + nextActivityUri
						+ " into Description");
			}
			userData.put("nextActivityUris", nextActivityUri.toString());
		} else {
			userData.put("returnToPreviousActivity", "true");
		}
	}

	private void resolveObject(final EObject eObject) {
		EcoreUtil2.resolveAll(eObject, new CancelIndicator() {
			@Override
			public boolean isCanceled() {
				return false;
			}
		});
	}

	private String getUriStrings(final List<? extends EObject> list) {
		final StringBuffer sb = new StringBuffer();
		for (int i = 0; i < list.size(); i++) {
			resolveObject(list.get(i));
			sb.append(EcoreUtil2.getURI(list.get(i)));
			if (i < (list.size() - 1)) {
				sb.append(",");
			}
		}
		return sb.toString();
	}

	private void createDescription(
			final IAcceptor<IEObjectDescription> acceptor,
			final EObject object, final Map<String, String> userData) {
		final QualifiedName qualifiedName = getQualifiedNameProvider()
				.getFullyQualifiedName(object);
		final IEObjectDescription description = EObjectDescription.create(
				qualifiedName, object, userData);
		acceptor.accept(description);
	}

}
