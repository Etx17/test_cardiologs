# Heart Rate Data Analysis Assignment

## Introduction

This document describes the process I followed and the considerations I made during the analysis of heart rate data for the assignment. Initially, the dataset showed unusual heart rate readings, which led to a deeper investigation into the data's integrity and physiological plausibility.

## Analysis Overview

### Identifying Anomalies in Data

Upon first glance at the data, I encountered heart rate readings **ranging between 17 and 3000 bpm**, which was indicative of potential issues in my data processing approach. However, a detailed analysis confirmed that the strange data did not result from processing errors but from instances where the data seemed physiologically impossible.

**Solution:** I addressed the issue by allowing users to set their own thresholds for data analysis, enabling personalized artifact identification.

### Data Validation Process

**Approach:** I assumed that the data was in the correct order and focused my efforts on processing the data. This involved ensuring that the data format was consistent and that any anomalies or outliers were appropriately addressed.

### Test

Coverage is minimal given the time given. I thought testing the core feature of analysis was the most important ones. With more time, I could have gone deeper and test my validator, controllers and models as well.
