package de.msg.xt.mdt.tdsl.tests.headless.usecase.parser

import de.msg.xt.mdt.tdsl.TDslInjectorProvider
import de.msg.xt.mdt.tdsl.tDsl.TestModel
import de.msg.xt.mdt.tdsl.tests.XtextParameterized
import de.msg.xt.mdt.tdsl.tests.XtextParameterized.Parameter
import de.msg.xt.mdt.tdsl.tests.XtextParameterized.Parameters
import de.msg.xt.mdt.tdsl.tests.headless.BasicTestSetupTest
import java.util.ArrayList
import javax.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextParameterized)
@InjectWith(TDslInjectorProvider)
class ExpressionScopingTest {
	
	@Inject extension ParseHelper<TestModel>
	@Inject extension ValidationTestHelper
	
	@Parameter(0)
	public String name
	
	@Parameter(1)
	public CharSequence preamble
	
	@Parameter(2)
	public String expression
	
	@Parameter(3)
	public CharSequence suffix
	
	@Parameters(name="{0}")
	def public static Iterable<Object[]> parameters() {
		new ArrayList<Object[]> => [
			add(#[	"testInitialActivity", 
					'''
					''', 
					"#refresh",
					''''''
			])
			add(#[	"testActivityOperationActivitySwitch", 
					'''
					#openEditor
					''', 
					"#saveAndClose",
					''''''
			])
			add(#[	"testControlOperationActivitySwitch",
					'''
					#searchField.search
					''',
					"#refreshSearch",
					''''''		
			])
			add(#[	"testInitialActivityFallback",
					'''
					#refresh
					''',
					"#operation1",
					''''''		
			])
			add(#[	"testBasicVariableExpression",
					'''
					val testVal = 
					''',
					"#searchField.getText",
					''''''		
			])
			add(#[	"testAfterVariableExpression",
					'''
					val testVal = #searchField.getText
					''',
					"#refresh",
					''''''		
			])
			add(#[	"testIfExpression",
					'''
					if(true) {
						#operation1
					} else {
						#operation1
					}
					''',
					"#refresh",
					''''''		
			])
			add(#[	"testActivityOperationSwitchInIfExpression",
					'''
					if(true) {
						#openEditor
						#saveAndClose
					} else {
						#openEditor
						#saveAndClose
					}
					''',
					"#refresh",
					''''''		
			])
			add(#[	"testControlOperationSwitchInIfExpression",
					'''
					if(true) {
						#searchField.search
						#refreshSearch
					} else {
						#searchField.search
						#refreshSearch
					}			
					''',
					"#refresh",
					''''''
			])
			add(#[	"testInitialActivityInExpect",
					'''
					#openEditor
					#saveAndClose
					expect DialogActivity if (true) {
					''',
					"#ok",
					'''}'''		
			])
			add(#[	"testAfterExpect",
					'''
					#openEditor
					#saveAndClose
					expect DialogActivity if (true) {
					}
					''',
					"#refresh",
					''''''		
			])
			add(#[	"testActivityOperationActivitySwitchInExpect",
					'''
					#openEditor
					#saveAndClose
					expect DialogActivity if (true) {
						#ok
					''',
					"#refresh",
					'''}'''		
			])
			add(#[	"testControlOperationActivitySwitchInExpect",
					'''
					#openEditor
					#saveAndClose
					expect DialogActivity if (true) {
						#dialogTextField.search
					''',
					"#refreshSearch",
					'''}'''		
			])
			add(#[	"testAfterXExpression",
					'''
					[ println(":-)") ]
					''',
					"#refresh",
					''''''		
			])
			add(#[	"testAfterAssert",
					'''
					assert [ println(":-)") ]
					''',
					"#refresh",
					''''''		
			])
			add(#[	"testReturnToLastActivity",
					'''
					#openEditor
					#openDialog
					#cancel
					''',
					"#saveAndClose",
					''''''		
			])
		]
	}
	
	@Test
	def void inUseCase() {
		'''
		«BasicTestSetupTest.BASIC_TEST_PREAMBLE»
			
			useCase SampleUseCase initial ViewActivity {
				«preamble + expression + suffix»
			}
		}
		'''.parse.assertNoErrors
	}
	
	@Test
	def void inActivityOperation() {
		'''
		«BasicTestSetupTest.BASIC_TEST_PREAMBLE»
			
			activity SampleTestActivity {
				
				field searchField control TextControl {
					op void setText(StringDT str)
					op StringDT getText
					op void search => SearchResult
				}
				op refresh
				op operation1
				op openEditor => EditorActivity 
				
				op activityOperation {
					«preamble + expression + suffix»
				}
			}
		}
		'''.parse.assertNoErrors
	}	
}