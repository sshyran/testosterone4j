/*
 * generated by Xtext
 */
package org.testosterone4j.tdsl.ui.contentassist

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.nodemodel.ICompositeNode
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import org.eclipse.xtext.xbase.XMemberFeatureCall
import org.eclipse.xtext.xbase.typesystem.IExpressionScope
import org.testosterone4j.tdsl.tDsl.OperationMapping
import org.eclipse.xtext.nodemodel.ICompositeNode;


/**
 * see http://www.eclipse.org/Xtext/documentation/latest/xtext.html#contentAssist on how to customize content assistant
 */
class TDslProposalProvider extends AbstractTDslProposalProvider {

	override String getDisplayString(EObject element,
			String qualifiedNameAsString, String shortName) {
		if (element instanceof OperationMapping) {
			return qualifiedNameAsString;
		}
		return super
				.getDisplayString(element, qualifiedNameAsString, shortName);
	}

	override protected isKeywordWorthyToPropose(Keyword keyword) {
		true
	}
	
	
	override completeXFeatureCall_Feature(EObject model, Assignment assignment, ContentAssistContext context,
			ICompletionProposalAcceptor acceptor) {
		if (model != null) {
			/* this is the only modification! 
			if (typeResolver.resolveTypes(model).hasExpressionScope(model, IExpressionScope.Anchor.WITHIN)) {
				return;
			}*/
		}
		if (model instanceof XMemberFeatureCall) {
			val ICompositeNode node = NodeModelUtils.getNode(model);
			val int endOffset = node.getEndOffset();
			if (isInMemberFeatureCall(model, endOffset, context)) {
				return;
			}
		}
		createLocalVariableAndImplicitProposals(model, IExpressionScope.Anchor.AFTER, context, acceptor);
	}
}
