//
//  ViewController.swift
//  chimney
//
//  Created by Kangwoo on 1/29/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        scrollView.delegate = self
//
//        slides = createSlides()
//        setupSlideScrollView(slides: slides)
//
//        pageControl.numberOfPages = slides.count
//        pageControl.currentPage = 0
//        view.bringSubviewToFront(pageControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
//    func setupSlideScrollView(slides: [Slide]) {
//        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
//        scrollView.isPagingEnabled = true
//
//        for i in 0 ..< slides.count {
//            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
//            scrollView.addSubview(slides[i])
//        }
//    }
//    // create slides
//    func createSlides() -> [Slide] {
//        let slide1: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
//        slide1.imageView.image = UIImage(named:"food delivery alt")
//        slide1.textView.text = "Need dinner? Out of something? Whatever it is, don't run out to the store. Ask a neighbor for it! Chimney lets you connect with nearby neighbors to get you the things you need."
//
//        let slide2: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
//        slide2.imageView.image = UIImage(named: "landing2")
//        slide2.textView.text = ""
//
//        let slide3: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
//        slide3.imageView.image = UIImage(named: "profile")
//        slide3.textView.text = ""
//
//        return [slide1, slide2, slide3]
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
//        pageControl.currentPage = Int(pageIndex)
//
//        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
//        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
//
//        // vertical
//        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
//        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
//
//        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
//        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
//
//
//        /*
//         * below code changes the background color of view on paging the scrollview
//         */
//        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
//
//
//        /*
//         * below code scales the imageview on paging the scrollview
//         */
//        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
//
//        if(percentOffset.x > 0 && percentOffset.x <= 0.33) {
//
//            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
//            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
//
//        } else if(percentOffset.x > 0.33 && percentOffset.x <= 0.66) {
//            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
//            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
//
//        }
//    }
    
    
    
}


