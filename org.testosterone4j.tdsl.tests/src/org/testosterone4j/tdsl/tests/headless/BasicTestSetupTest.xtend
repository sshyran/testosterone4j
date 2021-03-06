package org.testosterone4j.tdsl.tests.headless

import javax.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import org.testosterone4j.tdsl.TDslInjectorProvider
import org.testosterone4j.tdsl.tDsl.TestModel
import org.testosterone4j.tdsl.tests.util.TestExtensions
import org.junit.Assert

@RunWith(XtextRunner)
@InjectWith(TDslInjectorProvider)
class BasicTestSetupTest {
	
	public static val BASIC_TEST_PREAMBLE = '''
			package tdsl.testpackage {
				
				type String mappedBy String
				
				datatype StringDT type String {
					class shortString classValue "shortString"
				}

				control TextControl {
					op void setText(String str)
					op String getText
					op void search
				}
				
				control Button {
					op void push
				}
				
				toolkit Stdtoolkit using controls {
					TextControl
				}				
				
				activity EditorActivity {
					field shortName control TextControl {
						op void setText(StringDT str)
						op StringDT getText
						op void search
					}
					
					op openDialog => DialogActivity
					op saveAndClose => ViewActivity
				}
				
				activity ViewActivity {
					field searchField control TextControl {
						op void setText(StringDT str)
						op StringDT getText
						op void search => SearchResult
					}
					op refresh
					op operation1
					op append(StringDT appendStr)
					op openEditor => EditorActivity 
				}
				
				activity SearchResult {
					op refreshSearch
					op ok => returnToLastActivity
				}	
				
				activity DialogActivity {
					field dialogTextField control TextControl {
						op void setText(StringDT str)
						op StringDT getText
						op void search => SearchResult
					}
					op ok => ViewActivity
					op cancel => returnToLastActivity
				}
				
				useCase SampleTestUseCase initial EditorActivity {
					#shortName.setText
					#saveAndClose
				}
				
				useCase SampleTestUseCaseWithActivitySwitch initial ViewActivity {
					#openEditor
				} => EditorActivity
				
				useCase SampleTestUseCaseWithParameter(StringDT param) initial ViewActivity {
					#refresh
				}
				
				test SampleTestUseCaseTest generator org.testosterone4j.base.SampleTestGenerator useCase SampleTestUseCase
			'''
	
	@Inject extension ParseHelper<TestModel>
	@Inject extension ValidationTestHelper
	@Inject extension CompilationTestHelper
	@Inject extension TestExtensions
	
	
	def parseAndCompile(CharSequence cs) {
		cs.parse.assertNoErrors
//		cs.compile [
//			compileAllClasses
//		]	
	}
	
	@Test
	def void test_100_PackageDefinition() {
		'''
			package tdsl.testpackage {
			}
		'''.parseAndCompile
	}
	
	@Test
	def void test_200_TypeDefinition() {
		'''
			package tdsl.testpackage {
				
				type String mappedBy String
			}
		'''.parseAndCompile
	}
	
	@Test
	def void test_300_DataTypeDefinition() {
		'''
			package tdsl.testpackage {
				
				type String mappedBy String
				
				datatype StringDT type String {
					class shortString classValue "shortString"
				}
			}
		'''.parseAndCompile
	}
	
	@Test
	def void test_400_TagDefinition() {
		'''
			package tdsl.testpackage {

				tags {
					Empty, Invalid
				}				
			}
		'''.parseAndCompile			
	}
	
	@Test
	def void test_500_ControlDefinition() {
		'''
			package tdsl.testpackage {
				
				type String mappedBy String

				control TextControl {
					op void setText(String str)
					op String getText
				}				
			}
		'''.parseAndCompile		
	}
	
	@Test
	def void test_600_ToolkitDefinition() {
		'''
			package tdsl.testpackage {
				
				type String mappedBy String

				control TextControl {
					op void setText(String str)
					op String getText
				}
				
				control Button {
					op void push
				}
				
				toolkit Stdtoolkit using controls {
					TextControl, Button
				}				
			}
		'''.parseAndCompile			
	}
	
	@Test
	def void test_700_ActivityDefinition() {
		'''
			package tdsl.testpackage {
				
				type String mappedBy String
				
				datatype StringDT type String {
					class shortString classValue "shortString"
				}

				control TextControl {
					op void setText(String str)
					op String getText
				}
				
				toolkit Stdtoolkit using controls {
					TextControl
				}				
				
				activity EditorActivity {
					field shortName control TextControl {
						op void setText(StringDT str)
						op StringDT getText
					}
					
					op saveAndClose
				}
			}
		'''.parseAndCompile			
	}
	
	@Test
	def void test_701_ActivityDefinitionWithNavigation() {
		'''
			package tdsl.testpackage {
				
				type String mappedBy String
				
				datatype StringDT type String {
					class shortString classValue "shortString"
				}

				control TextControl {
					op void setText(String str)
					op String getText
				}
				
				toolkit Stdtoolkit using controls {
					TextControl
				}				
				
				activity EditorActivity {
					field shortName control TextControl {
						op void setText(StringDT str)
						op StringDT getText
					}
					
					op saveAndClose => ViewActivity
				}
				
				activity ViewActivity {
					field searchField control TextControl {
						op void setText(StringDT str)
						op StringDT getText
					}
					op refresh
					op openEditor => EditorActivity 
				}	
			}			
		'''.parseAndCompile
	}
	
	@Test
	def void test_701_ActivityDefinitionWithReturnToLastActivity() {
		'''
			package tdsl.testpackage {
				
				type String mappedBy String
				
				datatype StringDT type String {
					class shortString classValue "shortString"
				}

				control TextControl {
					op void setText(String str)
					op String getText
				}
				
				toolkit Stdtoolkit using controls {
					TextControl
				}				
				
				activity DialogActivity {
					op cancel => returnToLastActivity
				}	
			}			
		'''.parseAndCompile
	}
	
	@Test
	def void test_800_UseCaseDefinition() {
		'''
			package tdsl.testpackage {
				
				type String mappedBy String
				
				datatype StringDT type String {
					class shortString classValue "shortString"
				}

				control TextControl {
					op void setText(String str)
					op String getText
				}
				
				toolkit Stdtoolkit using controls {
					TextControl
				}				
				
				activity EditorActivity {
					field shortName control TextControl {
						op void setText(StringDT str)
						op StringDT getText
					}
					
					op saveAndClose
				}
				
				useCase SampleTestUseCase initial EditorActivity {
					#shortName.setText
					#saveAndClose
				}
			}
		'''.parseAndCompile			
	}

	@Test
	def void test_801_UseCaseDefinitionWithActivitySwitch() {
		'''
			package tdsl.testpackage {
				
				type String mappedBy String
				
				datatype StringDT type String {
					class shortString classValue "shortString"
				}

				control TextControl {
					op void setText(String str)
					op String getText
				}
				
				toolkit Stdtoolkit using controls {
					TextControl
				}				
				
				activity ViewActivity {
					op openEditor => EditorActivity 
				}
				
				activity EditorActivity {
					field shortName control TextControl {
						op void setText(StringDT str)
						op StringDT getText
					}
					
					op saveAndClose
				}
				
				useCase SampleTestUseCaseWithActivitySwitch initial ViewActivity {
					#openEditor
				} => EditorActivity
			}
		'''.parseAndCompile		
	}

	@Test
	def void test_900_TestDefinition() {
		'''
			package tdsl.testpackage {
				
				type String mappedBy String
				
				datatype StringDT type String {
					class shortString classValue "shortString"
				}

				control TextControl {
					op void setText(String str)
					op String getText
				}
				
				toolkit Stdtoolkit using controls {
					TextControl
				}				
				
				activity EditorActivity {
					field shortName control TextControl {
						op void setText(StringDT str)
						op StringDT getText
					}
					
					op saveAndClose
				}
				
				useCase SampleTestUseCase initial EditorActivity {
					#shortName.setText
					#saveAndClose
				}
				
				test SampleTestUseCaseTest generator org.testosterone4j.base.SampleTestGenerator useCase SampleTestUseCase
			}
		'''.parseAndCompile		
	}
	
	@Test
	def void test_1000_testBasicTestPramble() {
		'''
		«BASIC_TEST_PREAMBLE»
		}
		'''.parseAndCompile
	}
	
}