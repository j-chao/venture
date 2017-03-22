//
//  TripPageVC.swift
//  venture
//
//  Created by Justin Chao on 3/19/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class TripPageVC: UIPageViewController {
    
    var tripName:String!
    
    lazy var pages:[UIViewController] = {
        var arrayPages = [UIViewController]()
        
        for i in 1...tripLength { 
            arrayPages.append(self.newVC("VC"))
        }
        
        return arrayPages
    }()
    
    fileprivate func newVC(_ name: String) -> ItineraryVC
    {
        let newvc = UIStoryboard(name: "itinerary", bundle: nil).instantiateViewController(withIdentifier: "itinerary") as! ItineraryVC
        newvc.tripName = tripName
        return newvc
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstVC = pages.first as? ItineraryVC {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.green
        pageControl.backgroundColor = UIColor.lightGray
    }

}

extension TripPageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIdx = pages.index(of: viewController) else {
            return nil
        }
        let previousIdx = viewControllerIdx - 1
        guard previousIdx >= 0 else {
            return pages.last
        }
        return pages[previousIdx]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIdx = pages.index(of:viewController) else {
            return nil
        }
        let nextIdx = viewControllerIdx + 1
        guard pages.count > nextIdx else {
            return pages.first
        }
        return pages[nextIdx]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first,
            let firstVCIdx = pages.index(of: firstVC) else {
                return 0
        }
        return firstVCIdx
    }
}
