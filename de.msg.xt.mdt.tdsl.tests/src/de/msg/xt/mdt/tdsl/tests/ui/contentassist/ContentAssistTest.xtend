package de.msg.xt.mdt.tdsl.tests.ui.contentassist

import de.msg.xt.mdt.tdsl.TDslUiInjectorProvider
import de.msg.xt.mdt.tdsl.tests.XtextParameterized
import de.msg.xt.mdt.tdsl.tests.headless.BasicTestSetupTest
import org.eclipse.xtext.junit4.InjectWith
import org.junit.Test
import org.junit.runner.RunWith
import de.msg.xt.mdt.tdsl.tests.XtextParameterized.Parameters
import de.msg.xt.mdt.tdsl.tests.headless.ExpressionScopingTest
import de.msg.xt.mdt.tdsl.tests.XtextParameterized.Parameter
import de.msg.xt.mdt.tdsl.tests.headless.LocalScopingTest

@RunWith(XtextParameterized)
@InjectWith(TDslUiInjectorProvider)
class ContentAssistTest extends MyAbstractContentAssistTest {
	
	@Parameters(name="{0}")
	def public static Iterable<Object[]> parameters() {
		ExpressionScopingTest.parameters + LocalScopingTest.parameters
	}
	
	@Parameter(0)
	public String name
	
	@Parameter(1)
	public CharSequence preamble
	
	@Parameter(2)
	public String expression
	
	@Parameter(3)
	public CharSequence suffix
	
	@Test
	def void inUseCase() {
		val builder = newBuilder.append(BasicTestSetupTest.BASIC_TEST_PREAMBLE).append('''
			useCase SampleUseCase(StringDT param) initial ViewActivity {
		''')
		
		builder.append(preamble.toString).assertProposal(expression)
	}
	
	@Test
	def void inActivityOperation() {
		val builder = newBuilder.append(BasicTestSetupTest.BASIC_TEST_PREAMBLE).append('''
			activity SampleTestActivity {
				
				field searchField control TextControl {
					op void setText(StringDT str)
					op StringDT getText
					op void search => SearchResult
				}
				op refresh
				op operation1
				op append(StringDT appendStr)
				op openEditor => EditorActivity 
				
				op activityOperation(StringDT param) {
		''')
		
		builder.append(preamble.toString).assertProposal(expression)
	}
	
	@Test
	def void inInnerBlock() {
		val builder = newBuilder.append(BasicTestSetupTest.BASIC_TEST_PREAMBLE).append('''
			useCase SampleUseCase(StringDT param) initial ViewActivity {
				if (true) {
		''')
		
		builder.append(preamble.toString).assertProposal(expression)
	}
}
	