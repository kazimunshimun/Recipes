//
//  RecipeOverview.swift
//  Recipes
//
//

import SwiftUI

struct RecipeOverview: View {
    @ObservedObject var manager: RecipeManager
    public var viewSpace: Namespace.ID
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            // title view
            TitleView(manager: manager)
            ZStack {
                // interaction view with image
                RecipeInteractionView(
                    recipe: manager.data[manager.currentRecipeIndex],
                    index: manager.currentRecipeIndex,
                    count: manager.data.count,
                    manager: manager, viewSpace: viewSpace)
                    .rotationEffect(.degrees(Double(-manager.swipeHeight)))
                    .offset(x: UIScreen.screenWidth / 2)
                HStack {
                    // summary view
                    SummaryView(recipe: manager.data[manager.currentRecipeIndex])
                        .foregroundColor(manager.currentRecipeIndex%2 == 0 ? .black : .white)
                    Spacer()
                }
            }
            // description view
            DescriptionView(manager: manager)
            
            Spacer()
        }
    }
}

struct TitleView: View {
    @ObservedObject var manager: RecipeManager
    var body: some View {
        Text("Daily Cooking Quest")
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.gray)
        Text(manager.data[manager.currentRecipeIndex].title)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(manager.currentRecipeIndex%2 == 0 ? .black : .white)
    }
}

struct SummaryView: View {
    let recipe: Recipe
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(recipe.summary.sorted(by: <), id: \.key) { key, value in
                HStack(spacing: 12) {
                    Image(systemName: RecipeData.summaryImageName[key] ?? "")
                        .foregroundColor(.green)
                    Text(value)
                }
            }
            .font(.system(size: 17, weight: .semibold))
            
            HStack(spacing: 12) {
                Image(systemName: "chart.bar.doc.horizontal")
                    .foregroundColor(.green)
                Text("Healthy")
            }
        }
        .font(.system(size: 17, weight: .semibold))
    }
}

struct DescriptionView: View {
    @ObservedObject var manager: RecipeManager
    var body: some View {
        HStack(spacing: 12) {
            Text(manager.data[manager.currentRecipeIndex].description)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(manager.currentRecipeIndex%2 == 0 ? .black : .white)
            Button(action: {
                withAnimation {
                    manager.selectedRecipe = manager.data[manager.currentRecipeIndex]
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green)
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(45))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            })
            
            Spacer()
        }
    }
}

struct RecipeInteractionView: View {
    let recipe: Recipe
    let index: Int
    let count: Int
    @ObservedObject var manager: RecipeManager
    // add some matched geometry effect
    public var viewSpace: Namespace.ID
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            manager.currentRecipeIndex%2 == 0 ? Color.lightBackground.opacity(0.1) : Color.darkBackground.opacity(0.1),
                            Color.green,
                            Color.green
                        ]),
                      startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 4
                )
                .scaleEffect(1.15)
                .matchedGeometryEffect(id: "borderId", in: viewSpace, isSource: true)
            
            ArrowShape(reachedTop: index == 0, reachedBottom: index == count - 1)
                .stroke(Color.gray,
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .frame(width: UIScreen.screenWidth - 32, height: UIScreen.screenWidth - 32)
                .scaleEffect(1.15)
                .matchedGeometryEffect(id: "arrowId", in: viewSpace, isSource: true)
            
            Image(recipe.image)
                .resizable()
                .scaledToFit()
                .matchedGeometryEffect(id: "imageId", in: viewSpace, isSource: true)
            
            // this circle will be used to drag interaction
            Circle()
                .fill(Color.black.opacity(0.001))
                .scaleEffect(1.2)
                .gesture(
                    DragGesture(minimumDistance: 10)
                        .onChanged({ value in
                            withAnimation {
                                manager.changeSwipeValue(value: value.translation.height)
                            }
                        })
                        .onEnded({ value in
                            withAnimation {
                                manager.swipeEnded(value: value.translation.height)
                            }
                        })
                )
        }
    }
}

struct ArrowShape: Shape {
    let reachedTop: Bool
    let reachedBottom: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startAngle: CGFloat = 160
        let endAngle: CGFloat = 200
        
        let radius = rect.width/2
        
        let startAngleRadian = startAngle * CGFloat.pi / 180
        let endAngleRadian = endAngle * CGFloat.pi / 180
        
        let startPoint1 = CGPoint.pointOnCircle(center: CGPoint(x: radius, y: radius), radius: radius, angle: startAngleRadian)
        
        let endPoint1 = CGPoint.pointOnCircle(center: CGPoint(x: radius, y: radius), radius: radius, angle: endAngleRadian)
        
        path.addArc(
            center: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: .degrees(Double(startAngle)),
            endAngle: .degrees(Double(endAngle)),
            clockwise: false)
        
        if !reachedTop {
            let startAngleRadian2 = (startAngle + 4) * CGFloat.pi / 180
            let startPoint2 = CGPoint.pointOnCircle(center: CGPoint(x: radius, y: radius), radius: radius + 8, angle: startAngleRadian2)
            
            let startPoint3 = CGPoint.pointOnCircle(center: CGPoint(x: radius, y: radius), radius: radius - 8, angle: startAngleRadian2)
            
            path.move(to: startPoint1)
            path.addLine(to: startPoint2)
            path.move(to: startPoint1)
            path.addLine(to: startPoint3)
        }
        
        if !reachedBottom {
            let endAngleRadian2 = (endAngle - 4) * CGFloat.pi / 180
            let endPoint2 = CGPoint.pointOnCircle(center: CGPoint(x: radius, y: radius), radius: radius + 8, angle: endAngleRadian2)
            
            let endPoint3 = CGPoint.pointOnCircle(center: CGPoint(x: radius, y: radius), radius: radius - 8, angle: endAngleRadian2)
            
            path.move(to: endPoint1)
            path.addLine(to: endPoint2)
            path.move(to: endPoint1)
            path.addLine(to: endPoint3)
        }
        
        return path
    }
}
