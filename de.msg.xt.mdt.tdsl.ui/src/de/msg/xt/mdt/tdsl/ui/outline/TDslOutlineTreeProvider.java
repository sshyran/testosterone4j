/*
 * generated by Xtext
 */
package de.msg.xt.mdt.tdsl.ui.outline;

import org.eclipse.xtext.ui.editor.outline.IOutlineNode;
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider;
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode;

import de.msg.xt.mdt.tdsl.tDsl.ActivityOperation;
import de.msg.xt.mdt.tdsl.tDsl.Element;
import de.msg.xt.mdt.tdsl.tDsl.EquivalenceClass;
import de.msg.xt.mdt.tdsl.tDsl.Field;
import de.msg.xt.mdt.tdsl.tDsl.Import;
import de.msg.xt.mdt.tdsl.tDsl.Operation;
import de.msg.xt.mdt.tdsl.tDsl.PackageDeclaration;
import de.msg.xt.mdt.tdsl.tDsl.Predicate;
import de.msg.xt.mdt.tdsl.tDsl.TagsDeclaration;
import de.msg.xt.mdt.tdsl.tDsl.Test;
import de.msg.xt.mdt.tdsl.tDsl.TestModel;
import de.msg.xt.mdt.tdsl.tDsl.UseCase;

/**
 * customization of the default outline structure
 * 
 */
public class TDslOutlineTreeProvider extends DefaultOutlineTreeProvider {

	protected void _createChildren(DocumentRootNode parentNode,
			TestModel modelElement) {
		for (PackageDeclaration packageDecl : modelElement.getPackages()) {
			createNode(parentNode, packageDecl);
		}
	}

	protected void _createChildren(IOutlineNode parentNode,
			PackageDeclaration packageDecl) {
		for (Element element : packageDecl.getElements()) {
			if (!(element instanceof Import)) {
				createNode(parentNode, element);
			}
		}
	}

	protected void _createChildren(IOutlineNode parentNode, UseCase modelElement) {
	}

	protected boolean _isLeaf(UseCase modelElement) {
		return true;
	}

	protected void _createChildren(IOutlineNode parentNode,
			ActivityOperation modelElement) {
	}

	protected boolean _isLeaf(ActivityOperation modelElement) {
		return true;
	}

	protected void _createChildren(IOutlineNode parentNode,
			Operation modelElement) {
	}

	protected boolean _isLeaf(Operation modelElement) {
		return true;
	}

	protected void _createChildren(IOutlineNode parentNode, Field modelElement) {
	}

	protected boolean _isLeaf(Field modelElement) {
		return true;
	}

	protected void _createChildren(IOutlineNode parentNode,
			EquivalenceClass modelElement) {
	}

	protected boolean _isLeaf(EquivalenceClass modelElement) {
		return true;
	}

	protected void _createChildren(IOutlineNode parentNode, Test modelElement) {
	}

	protected boolean _isLeaf(Test modelElement) {
		return true;
	}

	protected void _createChildren(IOutlineNode parentNode,
			Predicate modelElement) {
	}

	protected boolean _isLeaf(Predicate modelElement) {
		return true;
	}

	protected Object _text(TagsDeclaration modelElement) {
		return "Tags";
	}

}
