import XCTest
import SwiftUI
@testable import ViewInspector

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
final class TupleViewTests: XCTestCase {
    
    func testSimpleTupleView() throws {
        let view = SimpleTupleView().padding()
        let sut = try view.inspect().view(SimpleTupleView.self)
        XCTAssertThrows(try sut.emptyView(),
                        "Unable to extract EmptyView: please specify its index inside parent view")
        XCTAssertNoThrow(try sut.emptyView(0))
        XCTAssertNoThrow(try sut.text(1))
    }
    
    func testTupleInsideTupleView() throws {
        let view = TupleInsideTupleView(flag: true)
        let string1 = try view.inspect().hStack().text(0).string()
        XCTAssertEqual(string1, "xyz")
        XCTAssertThrows(try view.inspect().hStack().text(1),
                        "Please insert .tupleView(1) after HStack for inspecting its children at index 1")
        let string2 = try view.inspect().hStack().tupleView(1).text(0).string()
        XCTAssertEqual(string2, "abc")
        let string3 = try view.inspect().hStack().tupleView(1).text(1).string()
        XCTAssertEqual(string3, "def")
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
private struct SimpleTupleView: View, Inspectable {
    var body: some View {
        EmptyView()
        Text("abc")
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
private struct TupleInsideTupleView: View, Inspectable {
    
    let flag: Bool
    var body: some View {
        HStack {
            Text("xyz")
            if flag {
                Text("abc")
                Text("def")
            }
        }
    }
}
